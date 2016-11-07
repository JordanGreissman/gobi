open Cluster
open Unit



(* A [Tile] is a module containing all the information about
 * tiles *)
module type Tile = sig


(* [terrianInformation] is a record holding information about the terrain
*)
  type terrain_information


    (*{movementObstruction: bool; costToMove: int;
                           needsClearing: bool; buildingRestriction: bool;
                          foodRestriction: bool}*)

(* [terrian] describes the type land on a specific tile
*)
  type terrain

    (*
  | Flatland of terrainInformation | Forest of terrainInformation
  | Mountain of terrainInformation | Desert of terrainInformation*)

  (* [id] is a type for id'ing tiles. Each id needs to be unique
 *)
  type id


(* [tile] describes the type of a specific tile on the map
*)
type tile
    (*
    {id: id; terrain: terrain; settled: bool; hub: hub option;
             bits: bit list}*)

(* [terrain] returns the type of terrain associated with the tile given by
 * it's [id] *)
  val get_terrain: id -> terrain

  (* [is_settled] returns bool indentified in tile given by it's [id] [settled]*)
  val get_settled:  id -> bool

  (* [get_hub] returns the type of hub associated with the tile given by
   * it's [id] *)
  val get_hub: id -> hub option

  (* [get_bits] returns the type of hub associated with the tile given by
   * it's [id] *)
  val get_bits: id -> bit list

  (* [get_tile] returns the tile from the given
   * [id] *)
  val get_tile: id -> tile

  (* [create_tile] returns a newly created tile with the given parameters
   *)
  val create_tile: id -> terrain -> bool -> hub option -> bit list -> tile

  (* [set_hub] updates the hub in the given tile
  *)
  val set_hub: id -> hub option -> tile

  (* [set_bits] updates the bits in the given tile
  *)
  val set_bits: id -> bit list -> tile

  (* [set_settled] updates the settled bool in the given tile
  *)
  val set_settled: id -> bool -> tile

end
