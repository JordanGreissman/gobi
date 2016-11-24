(** This type represents a coordinate in a hexagonal grid. We're using offset
  * coordinates -- a slight modification of cartesian coordinates to suit a
  * hexagonal grid. They look like this:
  *   ____        ____
  *  /(0,0)      /    \
  * /col   \____/(2,0) \
  * \ | row/====\==>   /
  *  \|___/ (1,0)\____/
  *  /|   \      /    \
  * / v    \____/ (2,1)\
  * \ (0,1)/    \      /
  *  \____/ (1,1)\____/
  *  /    \      /    \
  * / (0,2)\____/ (2,2)\
  * \      /    \      /
  *  \____/      \____/
  *)
type t

(* module type Screen = sig type t end *)
type lt_coordinate

val lt_add : (int*int) -> lt_coordinate -> lt_coordinate

val offset_from_lt : lt_coordinate -> t option

(* TODO: There needs to be a way to make lt_coordinates, but maybe this isn't the
 * best way. Reconsider later *)
val make_lt_coordinate : int -> int -> lt_coordinate
