type tile = Tile.t

type t = tile list list

(* Internally, there are 3 different coordinate types used for different purposes.
 * Specifically, cube coordinates lead to the simplest algorithms on hexagonal
 * grids. For descriptions and a comparison of the 3 different systems, please
 * see http://www.redblobgames.com/grids/hexagons/#coordinates
 *)
type axial_coordinate  = int * int
type cube_coordinate   = int * int * int
type offset_coordinate = int * int
(* offset coordinates are the ones we want to make publically visible *)
type coordinate = offset_coordinate

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

(* map generation *)
let generate width height =
  failwith "Unimplemented"

(* map operations *)
let tile_by_pos c map =
  failwith "Unimplemented"
