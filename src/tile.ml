type coordinate = Coord.t
type entity = Entity.t
type hub = Hub.t

type terrain = Flatland | Mountain | Forest | Desert

type t = {
  position : coordinate;
  terrain : terrain;
  entity : entity option;
  hub : hub option;
}

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

(* terrain property queries *)

let hasMovementObstruction t = match t.terrain with
  | Mountain -> true
  | _ -> false

let costToMove t = match t.terrain with
  | Flatland | Forest -> 1
  | Desert -> 2
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

let create ~terrain =
  failwith "Unimplemented"
