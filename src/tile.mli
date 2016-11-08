open Cluster
open Hub
open Entity

include Identifiable
include Describable

module type Terrain = sig
  (* the [info] type will be a record containing the following fields:
   *  - movementObstruction: bool; whether units are allowed on this tile
   *  - costToMove: int; the number of turns it takes unit to traverse this tile.
   *      For tiles where [movementObstruction = true], [costToMove = -1].
   *  - needsClearing: bool; whether this tile needs to be cleared before it can
   *      be settled.
   *  - buildingRestriction: bool; whether hubs are allowed on this tile
   *  - foodRestriction: bool
  *)
  type info
  type t =
    | Flatland of info
    | Mountain of info
    | Forest of info
    | Desert of info
end

(** the type of a tile *)
type t


(* TODO: Should setters return some kind of indication of whether or not the
 * set operation was successful? What could go wrong? *)

(* TODO: By taking [id] instead of [t], every function in this API is calling
 * into map.ml. Is that ok? *)

val get_terrain : id -> terrain
val set_terrain : id -> terrain -> unit

(* [is_settled] returns bool indentified in tile given by it's [id] [settled]*)
val is_settled : id -> bool
val settle : id -> unit
val unsettle : id -> unit

(* [get_hub] returns the type of hub associated with the tile given by
  * it's [id] *)
val get_hub : id -> hub option
val set_hub : id -> hub option -> unit

(* [get_bits] returns the type of hub associated with the tile given by
  * it's [id] *)
val get_entity : id -> entity list
val set_entity: id -> unit

(** [create_tile] returns a newly created tile with the given parameters *)
val create_tile : id -> terrain -> bool -> hub option -> entity list -> tile
