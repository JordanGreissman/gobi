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

module Screen = struct
  type t = int*int
  let origin = (0,0)
  let create x y = (x,y)
  let add (x1,y1) (x2,y2) = (x1+x2,y1+y2)
end

let origin = (0,0)

let create x y = (x,y)

let add (x1,y1) (x2,y2) = (x1+x2,y1+y2)

let to_string (x,y) = Printf.sprintf "(%d,%d)" x y

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

type offset_from_screen_t =
  | Contained of offset_coordinate
  | Border of offset_coordinate*(offset_coordinate option)*(offset_coordinate option)
  | None

(* ASSUMES A SIDE LENGTH OF 4 *)
let offset_from_screen ((x,y) : Screen.t) : offset_from_screen_t =
  match y mod 6 with
  | 0 -> (
    let x = x-3 in
    if x < 0 then None
    else if x mod 18 < 7 then
      if y = 0 then Border ((x/18*2,0),None,None)
      else if x mod 18 = 0 then Border ((x/18*2,y/6-1),Some (x/18*2,y/6),Some (x/18*2-1,y/6-1))
      else if x mod 18 = 6 then Border ((x/18*2,y/6-1),Some (x/18*2,y/6),Some (x/18*2+1,y/6-1))
      else Border ((x/18*2,y/6-1),Some (x/18*2,y/6),None)
    else if y = 0 then None
    else Contained (x/18*2+1,(y-3)/6))
  | 3 -> (
    if x = 0 then Border ((0,y/6),None,None)
    else match x mod 18 with
      | 0 ->
        if y = 3 then Border ((x/18*2,y/6),Some (x/18*2-1,y/6),None)
        else Border ((x/18*2,y/6),Some (x/18*2-1,y/6),Some (x/18*2-1,y/6-1))
      | 12 ->
        if y = 3 then Border ((x/18*2,y/6),Some (x/18*2+1,y/6),None)
        else Border ((x/18*2,y/6),Some (x/18*2+1,y/6-1),Some (x/18*2+1,y/6))
      | n when n < 12 -> Contained (x/18*2,y/6)
      | n when n > 12 ->
        if y = 3 then Border ((x/18*2+1,y/6),None,None)
        else Border ((x/18*2+1,y/6-1),Some (x/18*2+1,y/6),None)
      | _ -> failwith "Illegal value mod 18")
  | 1 | 5 -> (
    let x = x-2 in
    if x < 0 then None
    else match x mod 18 with
      | 0 ->
        if x=0 then Border ((x/18*2,y/6),None,None)
        else if y mod 6 = 1 then Border ((x/18*2-1,y/6-1),Some (x/18*2,y/6),None)
        else Border ((x/18*2-1,y/6),Some (x/18*2,y/6),None)
      | 8 ->
        if y=1 then Border ((x/18*2,0),None,None)
        else if y mod 6 = 1 then Border ((x/18*2,y/6),Some (x/18*2+1,y/6-1),None)
        else Border ((x/18*2,y/6),Some (x/18*2+1,y/6),None)
      | n when n < 8 -> Contained (x/18*2,y/6)
      | n when n > 8 -> if y = 1 then None else Contained (x/18*2+1,(y-3)/6)
      | _ -> failwith "Illegal value mod 18")
  | 2 | 4 -> (
    let x = x-1 in
    if x < 0 then None
    else match x mod 18 with
      | 0 ->
        if x=0 then Border ((x/18*2,y/6),None,None)
        else if y mod 6 = 2 then Border ((x/18*2-1,y/6-1),Some (x/18*2,y/6),None)
        else Border ((x/18*2-1,y/6),Some (x/18*2,y/6),None)
      | 10 ->
        if y=2 then Border ((x/18*2,0),None,None)
        else if y mod 6 = 2 then Border ((x/18*2,y/6),Some (x/18*2+1,y/6-1),None)
        else Border ((x/18*2,y/6),Some (x/18*2+1,y/6),None)
      | n when n < 10 -> Contained (x/18*2,y/6)
      | n when n > 10 -> if y = 2 then None else Contained (x/18*2+1,(y-3)/6)
      | _ -> failwith "Illegal value mod 18")
  | _ -> failwith "Illegal value mod 6"

