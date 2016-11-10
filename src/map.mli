(** a data structure which stores all of the tiles in the game *)
type t

(** a coordinate type. We're using hexagonal axial coordinates, which means one
  * coordinate axis is vertical, and the other is at a -30 degree angle to
  * horizontal. Like this:
  *   ____        ____
  *  /(0,0)      /    \
  * / q  p \____/(1,-1)\
  * \ |   \/    \      /
  *  \|___/\(1,0)\____/
  *  /|   \ \    /    \
  * / v    \_>__/ (2,0)\
  * \ (0,1)/    \      /
  *  \____/ (1,1)\____/
  *  /    \      /    \
  * / (0,2)\____/ (2,1)\
  * \      /    \      /
  *  \____/      \____/
  *
  * The axes are called p and q so as to not confuse their properties with those
  * of traditional (square) coordinate systems (mainly that they're orthogonal).
  *)
type coordinate

(** look up a tile by its coordinates *)
val tile_by_pos : coordinate -> t -> Tile.t option
