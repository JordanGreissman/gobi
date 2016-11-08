(** the type of a tile *)
type t

(* the [info] type will be a record containing the following fields:
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

(* TODO: Should setters return some kind of indication of whether or not the
 * set operation was successful? What could go wrong? *)

val get_terrain : t -> terrain
val set_terrain : t -> terrain -> unit

(* [is_settled] returns bool indentified in tile given by it's [id] [settled]*)
val is_settled : t -> bool
val settle : t -> unit
val unsettle : t -> unit

(* [get_hub] returns the type of hub associated with the tile given by
  * it's [id] *)
val get_hub : t -> Hub.t option
val set_hub : t -> Hub.t option -> unit

val get_entity : t -> entity list
val set_entity: t -> unit

(** [create_tile] returns a newly created tile with the given parameters *)
val create_tile : t -> terrain -> bool -> hub option -> entity list -> tile
