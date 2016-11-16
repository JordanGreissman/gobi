(** the type of a tile *)
type t

(* the info type will be a record containing the following fields:
 *  - movementObstruction: bool; whether units are allowed on this tile
 *  - costToMove: int; the number of turns it takes unit to traverse this tile.
 *      For tiles where [movementObstruction = true], [costToMove = -1].
 *  - needsClearing: bool; whether this tile needs to be cleared before it can
 *      be settled.
 *  - buildingRestriction: bool; whether hubs are allowed on this tile
 *  - foodRestriction: bool
 *)
type terrain_info

(** a tile can have one of these terrain types *)
type terrain =
  | Flatland of terrain_info
  | Mountain of terrain_info
  | Forest of terrain_info
  | Desert of terrain_info

(** getters and setters *)
val get_terrain : t -> terrain
val set_terrain : t -> terrain -> t

val is_settled : t -> bool
val settle : t -> t
val unsettle : t -> t

val get_hub : t -> Hub.t option
val set_hub : t -> Hub.t option -> t

val get_entity : t -> Entity.t option (* only one entity is allowed per tile *)
val set_entity : t -> Entity.t option -> t

(** [create] returns a newly created tile with the given parameters *)
val create : terrain -> bool -> Hub.t option -> Entity.t list -> t
