(** a data structure which stores all of the tiles in the game *)
type t

(** look up a tile by its ID *)
val tile_by_id : t -> Tile.id -> Tile.t option
