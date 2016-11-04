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
             units: unit list}*)

(* [terrain] returns the type of terrain associated with the tile given by
 * it's [id] *)
  val terrain: id -> terrain

  (* [is_settled] returns bool indentified in tile given by it's [id] [settled]*)
  val is_settled:  id -> bool

  (* [hub] returns the type of hub associated with the tile given by
   * it's [id] *)
  val hub: id -> hub option

  (* [units] returns the type of hub associated with the tile given by
   * it's [id] *)
  val units: id -> unit list





end
