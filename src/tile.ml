type coordinate = Coord.t
type entity = Entity.t
type entity_role = Entity.role
type hub = Hub.t
type hub_role = Hub.role

type terrain = Flatland | Mountain | Forest | Desert

type t = {
  pos : coordinate;
  terrain : terrain;
  entity : entity option;
  hub : hub option;
}

let create ~terrain ~pos = {
  pos     = pos;
  terrain = terrain;
  entity  = None;
  hub     = None;
}

let describe t =
  failwith "Unimplemented"

let place_hub ~role ~starting_entity ~tile =
  let production_rate = match starting_entity with
    (* TODO production rate questions:
     *  - how much does production increase per entity added? Is it the same for
     *    all hubs?
     *)
    (* TODO remove the entity [e] from the game (it is consumed by the hub) *)
    | Some e ->
      List.map (fun x -> x+1) (Hub.get_role_default_production_rate role)
    | None   -> Hub.get_role_default_production_rate role in
  let def = Hub.get_role_default_defense role in
  let h = Hub.create
      ~role:role
      ~production_rate:production_rate
      ~def:def
      ~pos:tile.pos in
  { tile with hub=(Some h) }

let move_entity to_tile from_tile =
  failwith "Unimplemented"

(* getters and setters *)

let get_terrain t =
  failwith "Unimplemented"

let set_terrain t terrain =
  failwith "Unimplemented"

let is_settled t =
  failwith "Unimplemented"

let settle t =
  failwith "Unimplemented"

let unsettle t =
  failwith "Unimplemented"

let get_hub t =
  failwith "Unimplemented"

let set_hub t hub =
  failwith "Unimplemented"

let get_entity t =
  failwith "Unimplemented"

let set_entity t =
  failwith "Unimplemented"

let get_pos t = t.pos

(* terrain property queries *)

let describe_terrain = function
  | Flatland -> "This is a flatland"
  | Mountain -> "This is a mountain"
  | Forest -> "This is a forest"
  | Desert -> "This is a desert"

let flatland_art = Art.load "flatland"
let mountain_art = Art.load "mountain"
let forest_art = Art.load "forest"
let desert_art = Art.load "desert"
let get_terrain_art = function
  | Flatland -> flatland_art
  | Mountain -> mountain_art
  | Forest -> forest_art
  | Desert -> desert_art

let has_movement_obstruction t = match t.terrain with
  | Mountain -> true
  | _ -> false

let cost_to_move t = match t.terrain with
  | Flatland | Desert -> 1
  | Forest -> 2
  | _ -> -1

let needs_clearing t = match t.terrain with
  | Forest -> true
  | _ -> false

let has_building_restriction t = match t.terrain with
  | Mountain -> true
  | _ -> false

let has_food_restriction t = match t.terrain with
  | Desert -> true
  | _ -> false

(* ============================================================== *)

let get_art_char c t =
  let ax,ay =
    let index x lst =
      let rec f i = function
      | []   -> raise Not_found
      | h::t -> if h=x then i else f (i+1) t in
      f 0 lst in
    let f i x = try Some (i,index c x) with Not_found -> None in
    let g x = match x with Some _ -> true | None -> false in
    let l = t.pos |> Coord.screen_from_offset |> List.mapi f |> List.filter g in
    match List.length l with
    | 0 -> failwith
             (Printf.sprintf
                "Coordinate %s not contained in tile %s"
                (Coord.Screen.to_string c)
                (Coord.to_string t.pos))
    | 1 -> (match List.hd l with
        | Some x -> x
        | None -> failwith "?????")
    | _ -> failwith "Duplicate coordinate found" in
  let e () = match t.entity with
    | Some e -> (
      let cell = List.nth (List.nth (Entity.get_art e) ax) ay in
      match cell with
      | Some c -> Some c
      | None -> raise Not_found)
    | None -> raise Not_found in
  let h () = match t.hub with
    | Some h -> (
      let cell = List.nth (List.nth (Hub.get_art h) ax) ay in
      match cell with
      | Some c -> Some c
      | None -> raise Not_found)
    | None -> raise Not_found in
  try e () with Not_found ->
  try h () with Not_found ->
  List.nth (List.nth (get_terrain_art t.terrain) ax) ay
