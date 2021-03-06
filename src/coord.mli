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

(** Returns the offset coordinate (0,0) *)
val origin : t
(** [create x y] is a new offset coordinate that represents ([x],[y]) *)
val create : int -> int -> t
(** [add a b] is the offset coordinate obtained when [a] is added to [b] *)
val add : t -> t -> t
(** [get_x c] is the x component of offset coordinate [c] *)
val get_x : t -> int
(** [get_y c] is the y component of offset coordinate [c] *)
val get_y : t -> int
(** [to_string c] is the string representation of [c] *)
val to_string : t -> string

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
  (** [get_x c] is the x component of screen coordinate [c] *)
  val get_x : t -> int
  (** [get_y c] is the y component of screen coordinate [c] *)
  val get_y : t -> int
  (** [to_string c] is the string representation of [c] *)
  val to_string : t -> string
end

(** [screen_from_offset c] is a list of lists of [Screen.t] coordinates contained
  * within the tile at offset coordinate [c]. The inner lists represent rows
  * in the hexagon tile, so the structure is pictorally thus:
  * [
  *   [         a2, a3, a4, a5, a6, a7, a8          ];
  *   [     b1, b2, b3, b4, b5, b6, b7, b8, b9      ];
  *   [ c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 ];
  *   [     d1, d2, d3, d4, d5, d6, d7, d8, d9      ];
  *   [         e2, e3, e4, e5, e6, e7, e8          ];
  * ]
  *)
val screen_from_offset : t -> Screen.t list list

(** this type represents the possibilities when a [Screen.t] coordinate is
  * converted into a [t] coordinate *)
type offset_from_screen_t =
  (** this screen coordinate is contained within the tile at the [t] coordinate
    * given as a parameter *)
  | Contained of t
  (** this screen coordinate exists on the border of between one and three tiles.
    * Since only one tile is guaranteed, the other two are given as options *)
  | Border of t*(t option)*(t option)
  (** this screen coordinate does not exist within any tile or on the border of
    * any tile *)
  | None

(** [offset_from_screen s] is the hex tile (represented in offset coordinates)
  * which contains the screen coordinate [s]. If [s] falls outside of a hex tile
  * or is on the border between two hex tiles, this function is [None].
  *)
val offset_from_screen : Screen.t -> offset_from_screen_t
