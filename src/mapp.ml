type tile = Tile.t

type t = tile list list

(* map operations *)
let tile_by_pos c map =
  let x,y = (Coord.get_x c,Coord.get_y c) in
  let row = try List.nth map y with
    | Failure _ -> failwith "y coordinate too large"
    | Invalid_argument _ -> failwith "y coordinate is negative" in
  try List.nth row x with
    | Failure _ -> failwith "x coordinate too large"
    | Invalid_argument _ -> failwith "x coordinate is negative"

(* map generation *)
let generate width height =
  let generate_tile x y =
    let terrain = match Random.int 10 with
    | n when n < 5           -> Tile.Flatland
    | n when 5 <= n && n < 7 -> Tile.Desert
    | n when 7 <= n && n < 9 -> Tile.Forest
    | _                      -> Tile.Mountain in
    let pos = Coord.create x y in
    Tile.create terrain pos in
  let a = Array.make_matrix height width (generate_tile 0 0) in
  for j = 0 to (height-1) do
    let row = Array.get a j in
    for i = 0 to (width-1) do
      row.(i) <- (generate_tile i j)
    done;
    a.(j) <- row
  done;
  let arr_lst = Array.map Array.to_list a in
  Array.to_list arr_lst


