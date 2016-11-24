type coordinate = Coord.t
type entity = Entity.t
type hub = Hub.t

type terrain = Flatland | Mountain | Forest | Desert

type t = {
  pos : coordinate;
  terrain : terrain;
  entity : entity option;
  hub : hub option;
}

let create ~terrain =
  failwith "Unimplemented"

let describe t =
  failwith "Unimplemented"

let place_hub ~name ~descr ~starting_entity ~production ~production_rate ~allowed_roles ~def ~tile =
  let h = Hub.create
      ~name:name
      ~descr:descr
      ~starting_entity:starting_entity
      ~production:production
      ~production_rate:production_rate
      ~allowed_roles:allowed_roles
      ~def:def
      ~pos:tile.pos in
  { tile with hub=(Some h) }

let move_entity to_tile from_tile =
  failwith "Unimplemented"

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

(* TODO: ascii art system *)
let get_art_char t ltc =
  failwith "Unimplemented"

(* terrain property queries *)

let describe_terrain = function
  | Flatland -> "This is a flatland"
  | Mountain -> "This is a mountain"
  | Forest -> "This is a forest"
  | Desert -> "This is a desert"

let hasMovementObstruction t = match t.terrain with
  | Mountain -> true
  | _ -> false

let costToMove t = match t.terrain with
  | Flatland | Desert -> 1
  | Forest -> 2
  | _ -> -1

let needsClearing t = match t.terrain with
  | Forest -> true
  | _ -> false

let hasBuildingRestriction t = match t.terrain with
  | Mountain -> true
  | _ -> false

let hasFoodRestriction t = match t.terrain with
  | Desert -> true
  | _ -> false
