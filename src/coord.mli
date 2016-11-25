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

(** The terminal is broken up into cells. Each cell can display one character.
 *  These coordinates represent the absolute position of cells. That is,
 *  the Screen.t coordinate (0,0) always corresponds to the cell in the top left
 *  corner of the game map; the ascii art in all tiles on the map have Screen.t
 *  coordinates that doesn't change over the course of the game. The top left
 *  corner of the terminal (which is *not* a Screen.t coordinate) corresponds to
 *  a Screen.t coordinate that changes as the player moves the map around.
 *)
module Screen : sig
  (** This type represents terminal cell coordinates. These are used to draw on
    * the terminal (the "screen") *)
  type t
  (** the screen coordinate (0,0) *)
  val origin : t
  (** [create x y] is a new screen coordinate that represents ([x],[y]) *)
  val create : int -> int -> t
  (** [add a b] is the screen coordinate obtained when [a] is added to [b] *)
  val add : t -> t -> t
end

(** [offset_from_screen s] is the hex tile (represented in offset coordinates)
  * which contains the screen coordinate [s]. If [s] falls outside of a hex tile
  * or is on the border between two hex tiles, this function is [None].
  *)
val offset_from_screen : Screen.t -> t option
