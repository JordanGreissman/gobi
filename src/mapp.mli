(** a data structure which stores all of the tiles in the game *)
type t

(** Look up and return a tile by its coordinates on a valid map. Will
  * return a tile of the boundaries if the coordinate isn't on map *)
val tile_by_pos : Coord.t -> t -> Tile.t

(** Return all tiles directly adjacent to the tile *)
val get_adjacent_tiles: t -> Tile.t -> Tile.t list

(** Procedurally generate a map. The first argument is the width of the map, and
  * the second is the height *)
val generate : int -> int -> t

(** Place a tile on a valid map *)
val set_tile : Tile.t -> t -> t

(** Select a random tile on a valid map *)
val get_random_tile : t -> Tile.t

(** Find the nearest empty tile to a tile *)
val get_nearest_available_tile : Tile.t -> t -> Tile.t