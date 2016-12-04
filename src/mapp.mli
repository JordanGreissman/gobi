(** a data structure which stores all of the tiles in the game *)
type t

(** look up a tile by its coordinates *)
val tile_by_pos : Coord.t -> t -> Tile.t

val get_adjacent_tiles: t -> Tile.t -> Tile.t list

(** procedurally generate a map. The first argument is the width of the map, and
  * the second is the height *)
val generate : int -> int -> t

val set_tile : Tile.t -> t -> t

val get_random_tile : t -> Tile.t

val get_nearest_available_tile : Tile.t -> t -> Tile.t