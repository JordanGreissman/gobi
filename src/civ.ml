open Exception

type t = {
   name : string;
   desc : string;
   entities : Entity.t list;
   pending_entities : Entity.t list;
   clusters : Cluster.t list;
   pending_hubs : Hub.t list;
   unlocked_entities : Entity.role list;
   resources : (Resource.t * int) list;
   techs : Research.Research.research_list;
   player_controlled : bool;
   next_id : int;
}

let get_player_controlled civ = civ.player_controlled
let get_tree civ = civ.techs
let get_resources civ = civ.resources
let get_entities civ = civ.entities

let rec cluster_map clust_func civ acc = match civ.clusters with
  | [] -> { civ with clusters = acc }
  | cluster::lst ->
    cluster_map clust_func { civ with clusters = lst }
      (acc@[clust_func cluster])

let rec hub_map_poly hub_func fallback civ =
  let tile_func t = match Tile.get_hub t with
    | Some hub -> hub_func hub | None -> fallback in
  let clust_func c = List.map tile_func (Cluster.get_tiles c) in
  List.flatten (List.map clust_func civ.clusters)

let score civ =

  let food_amt = try snd (Resource.find_res "food" (get_resources civ)) with
    | Illegal _ -> 0 in
  let entity_amt = List.length (get_entities civ) in
  let food_entity_bool = food_amt >= entity_amt in

  let rec sum_list lst = match lst with
    | [] -> 0 | h::t -> h + (sum_list t) in
  let total_prod_rate = sum_list (hub_map_poly Hub.get_production_rate 0 civ) in

  let rec sum_tuple_list lst = match lst with
    | [] -> 0 | (k, v)::t -> v + (sum_tuple_list t) in
  let no_food_func (r, v) = match r with | Resource.Food -> false | _ -> true in
  let no_food_list = List.filter no_food_func (get_resources civ) in
  let total_res = sum_tuple_list no_food_list in

  let rec sum_float_list lst = match lst with
    | [] -> 0.0 | h::t -> h +. (sum_float_list t) in
  let res_frac = sum_float_list
    (List.map (fun b -> Research.Research.frac_unlocked b) (get_tree civ)) in

  let food_score = if food_entity_bool then 500 else 0 in
    food_score + total_prod_rate + total_res + int_of_float (res_frac *. 100.0)

let rec get_resource_for_turn civ =
  let resource_lst hub = List.flatten (
    List.map (fun p -> if Hub.is_resource p then
      [Hub.prod_to_resource p] else [])
    (Hub.get_role_production hub) ) in
  let hub_func hub = List.map (fun resource ->
    (resource, Hub.get_production_rate hub))
    (resource_lst (Hub.get_role hub)) in
  let new_resources = List.flatten (hub_map_poly hub_func [] civ) in
  { civ with resources =
    Resource.add_resources civ.resources new_resources }

let add_unlocked_entity new_role civ =
  { civ with unlocked_entities = new_role::civ.unlocked_entities }

let rec apply_research u civ = match Research.Unlockable.treasure u with
  | Hub (role, amt) ->
    let tile_func tile = match Tile.get_hub tile with
      | Some hub -> Tile.set_hub tile
        (Some (Hub.change_production_rate amt hub))
      | _ -> tile in
    cluster_map (Cluster.tile_map (tile_func) []) civ []
  | Production (role, prod_lst) ->
    let tile_func tile = match Tile.get_hub tile with
      | Some hub -> if (Hub.get_role hub) = role then
        Tile.set_hub tile (Some (Hub.addto_role_production prod_lst hub))
        else tile
      | None -> tile in
      cluster_map (Cluster.tile_map (tile_func) []) civ []
  | _ -> raise (BadInvariant ("civ","apply_research","Expected a valid Unlockable"))

let remove_entity entity civ =
  let new_e_list = List.filter (fun e -> not (e = entity)) civ.entities in
    { civ with entities = new_e_list }

let replace_entity new_entity civ =
  let entities = List.filter (fun x ->
                              (Entity.get_id x) <> (Entity.get_id new_entity))
                                civ.entities in
  let entities = new_entity::entities in
  {civ with entities=entities}
  (* let id = Entity.get_id new_entity in
  let to_be_removed = List.find (fun e -> (Entity.get_id e) = id) civ.entities in
  let new_e_list = new_entity::(remove_entity to_be_removed civ).entities in
    { civ with entities = new_e_list } *)

let add_entity entity_role tile civ =
  let id = civ.next_id in
  (* TODO make sure it's unlocked *)
  let entity = Entity.create entity_role (Tile.get_pos tile) id in
  {civ with pending_entities=entity::civ.pending_entities;
            next_id=civ.next_id+1}

let add_entity_to_hub entity hub civ =
  if List.mem (Entity.get_role entity) (Hub.get_allowed_roles hub) then
    let parsed_clusters = List.map
      (fun c -> Cluster.add_entity_to_hub entity hub c) civ.clusters in
    let new_civ = { civ with clusters = parsed_clusters } in
      remove_entity entity new_civ
  else raise (Exception.Illegal "This entity has the wrong role for the hub"); civ

let unlock_if_possible key tree civ =
  let next_unlockable = match Research.Research.get_next_unlockable key tree with
    | Some u -> u | None -> raise (Illegal "You've unlocked everything in this field!") in
  let unlock_cost = (Research.Unlockable.resource next_unlockable,
    Research.Unlockable.resource_needed next_unlockable) in
  try
    let unlock_have = Resource.find_res (Resource.res_to_str (fst unlock_cost)) civ.resources in
    if (snd unlock_cost) <= (snd unlock_have) then
      (* let new_tree = Research.Research.replace_unlockable unlocked tree in *)
      { civ with techs        = (Research.Research.unlock key tree);
                 resources    = Resource.change_resource
                  (Resource.res_to_str (fst unlock_cost)) (snd unlock_cost) civ.resources
        }
    else raise (Illegal "You don't have enough resources!")
  with | Illegal _ -> raise (Illegal "You can't unlock this!")

(* delete? *)
let check_hub_cost hub civ =
  failwith "Civ.check_hub_cost is unimplemented"
