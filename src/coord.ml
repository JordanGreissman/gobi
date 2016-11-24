(* Internally, there are 3 different coordinate types used for different purposes.
 * Specifically, cube coordinates lead to the simplest algorithms on hexagonal
 * grids. For descriptions and a comparison of the 3 different systems, please
 * see http://www.redblobgames.com/grids/hexagons/#coordinates
 *)
type axial_coordinate  = int * int
type cube_coordinate   = int * int * int
type offset_coordinate = int * int
(* offset coordinates are the ones we want to make publically visible *)
type t = offset_coordinate

(* The terminal is broken up into cells. Each cell can display one character.
 * These coordinates represent the absolute position of cells. That is,
 * the Screen.t coordinate (0,0) always corresponds to the cell in the top left
 * corner of the game map; the ascii art in all tiles on the map have Screen.t
 * coordinates that doesn't change over the course of the game. The top left
 * corner of the terminal (which is *not* a Screen.t coordinate) corresponds to
 * a Screen.t coordinate that changes as the player moves the map around.
 *)
(* module Screen:Screen = struct type t = int*int end *)
(* type lt_coordinate = Screen.t *)
type lt_coordinate = int*int

(* coordinate conversion functions *)

let offset_from_cube ((x,y,z) : cube_coordinate) : offset_coordinate =
  let col = x in
  let row = z + (x - (x land 1)) / 2 in
  (row,col)

let cube_from_offset ((row,col) : offset_coordinate) : cube_coordinate =
  let x = col in
  let z = row - (col - (col land 1)) / 2 in
  let y = -x - z in
  (x,y,z)

let axial_from_cube ((x,y,z) : cube_coordinate) : axial_coordinate = (z,x)

let cube_from_axial ((p,q) : axial_coordinate) : cube_coordinate = (q,-p-q,p)

let axial_from_offset (oc : offset_coordinate) : axial_coordinate =
  let cc = cube_from_offset oc in
  axial_from_cube cc

let offset_from_axial (ac : axial_coordinate) : offset_coordinate =
  let cc = cube_from_axial ac in
  offset_from_cube cc

(* =========================================================================== *)

let lt_add (x,y) (ox,oy) = (ox+x,oy+y)

let offset_from_lt (lt : lt_coordinate) : offset_coordinate option =
  failwith "Unimplemented"

let make_lt_coordinate x y = (x,y)
