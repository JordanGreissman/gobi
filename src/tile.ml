open Exception

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

(** Create a hub and place it on this tile, also returning a potentially
  * different civ. For descriptions of the named parameters, see hub.mli.
  * IMPORTANT: if entity not None you must call Civ.remove_entity starting_entity
  * civ after.
  * [starting_entity] is an entity that will automatically be consumed by the
  *   new hub when it is finished being built, if such an entity exists.
  *   Typically this is the first entity to start construction of the hub.
  *)
let place_hub ~role ~starting_entity ~tile =
  let d = Hub.get_role_default_production_rate role in
  let production_rate = match starting_entity with
    | Some e -> d+1
    | None   -> d in
  let def = Hub.get_role_default_defense role in
  let pos = tile.pos in
  let h = Hub.create role production_rate def pos in
    { tile with hub=(Some h) }

let move_entity to_tile from_tile =
  if to_tile.entity = None
  then
    let current_entity = from_tile.entity in
    ({to_tile with entity=current_entity}, {from_tile with entity=None})
  else (to_tile, from_tile)

(* getters and setters *)

let get_terrain t = t.terrain
let set_terrain t terrain = {t with terrain=terrain}

let is_settled t = not(t.hub = None)
let unsettle t = {t with hub=None}

let clear t = match t.terrain with
  | Flatland | Mountain | Desert -> raise (Illegal "Cannot clear this terrain type")
  | Forest -> { t with terrain = Flatland }

let get_hub t = t.hub
let set_hub t hub =
  if is_settled t
  then t
  else {t with hub=hub}

let get_entity t = t.entity
let set_entity t entity = { t with entity=entity }

let get_pos t = t.pos

(* terrain property queries *)

let describe_terrain = function
  | Flatland -> "This is a flatland tile"
  | Mountain -> "This is a mountain tile"
  | Forest -> "This is a forest tile"
  | Desert -> "This is a desert tile"

let describe t =
  match t.entity, t.hub with
  | None, None ->
    (describe_terrain t.terrain)^"."
  | Some x, None ->
    (describe_terrain t.terrain)^". "^
      "It currently has a "^(Entity.describe x)^" on it."
  | None, Some y ->
    (describe_terrain t.terrain)^". "^
      "It currently has a "^(Hub.describe y)^" on it."
  | Some x, Some y ->
    (describe_terrain t.terrain)^". "^
      "It currently has a "^(Entity.describe x)^" and a "
      ^(Hub.describe y)^"on it."

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
    | 0 -> raise (BadInvariant (
        "tile",
        "get_art_char",
        (Printf.sprintf
          "Coordinate %s not contained in tile %s"
          (Coord.Screen.to_string c)
          (Coord.to_string t.pos))))
    | 1 -> (match List.hd l with
        | Some x -> x
        | None -> raise (BadInvariant ("tile","get_art_char","Expected Some but got None")))
    | _ -> raise (BadInvariant (
        "tile",
        "get_art_char",
        "Duplicate coordinate found")) in
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
