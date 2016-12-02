
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

(** Applies a function for clusters on every cluster in a civ. Acc should be [].
  * Returns civ with new cluster list *)
let rec cluster_map clust_func civ acc = match civ.clusters with
  | [] -> { civ with clusters = acc }
  | cluster::lst ->
    cluster_map clust_func { civ with clusters = lst } 
      (acc@[clust_func cluster]) 
      
(*
(** Applies a function to every hub in a civ. Acc should be []. 
  * Returns a civ with a new hub list *)
let rec hub_map hub_func civ acc = 
  let tile_func tile = match tile.hub with
      | Some hub -> { tile with hub = hub_func hub }
      | None -> tile in
  cluster_map (Cluster.tile_map tile_func []) civ acc
*)

(** apply map function to each hub in civ, returning some 'a list *)
let rec hub_map_poly hub_func fallback civ = 
  let tile_func t = match Tile.get_hub t with
    | Some hub -> hub_func hub | None -> fallback in
  let clust_func c = List.map tile_func (Cluster.get_tiles c) in
  List.flatten (List.map clust_func civ.clusters)

(* Returns civ with added resrouces for the turn *)
let rec get_resource_for_turn civ = 
  let resource_lst hub = List.flatten (
    List.map (fun p -> if Resource.is_resource p then 
      [Hub.prod_to_resource p] else []) 
    (Hub.get_role_production hub) ) in
  let hub_func hub = List.map (fun resource -> 
    (resource, Hub.get_production_rate hub)) 
    (resource_lst (Hub.get_role hub)) in
  let new_resources = List.flatten (hub_map_poly hub_func [] civ) in
  { civ with resources = 
    Resource.add_resources civ.resources new_resources }

(* Returns new civ with entity role added that's been unlocked *)
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
  | _ -> failwith "Not a valid unlockable type"; civ

(** Returns civ with an entity list without the passed in entity *)
let remove_entity entity civ =
  let new_e_list = List.filter (fun e -> not (e = entity)) civ.entities in
    { civ with entities = new_e_list }

(** Replace entity with id of new_entity with new_entity *)
let replace_entity new_entity civ =
  let id = Entity.get_id new_entity in
  let to_be_removed = List.find (fun e -> (Entity.get_id e) = id) civ.entities in
  let new_e_list = new_entity::(remove_entity to_be_removed civ).entities in
    { civ with entities = new_e_list }

(** Add entity to a hub in existing civ, returning the new civ.
  * Raise Illegal if entity role isn't allowed in the hub. Does nothing if hub
  * doesn't exist in clusters. *)
let add_entity_to_hub entity hub civ =
  if List.mem (Entity.get_role entity) (Hub.get_allowed_roles hub) then
    let parsed_clusters = List.map
      (fun c -> Cluster.add_entity_to_hub entity hub c) civ.clusters in
    let new_civ = { civ with clusters = parsed_clusters } in
      remove_entity entity new_civ
  else raise (Exception.Illegal "This entity has the wrong role for the hub"); civ

(** Returns true if the civ isn't run by AI *)
let get_player_controlled civ = civ.player_controlled
