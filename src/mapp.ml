open Exception

type tile = Tile.t

type t = tile list list

let tile_by_pos c map =
  let x,y = (Coord.get_x c,Coord.get_y c) in
  let row = try List.nth map y with
    | Failure _ -> List.nth map ((List.length map) - 1)
    | Invalid_argument _ -> List.nth map 0 in
  try List.nth row x with
    | Failure _ -> List.nth row ((List.length map) - 1)
    | Invalid_argument _ -> List.nth row 0

let get_adjacent_tiles map tile =
  let x = Coord.get_x (Tile.get_pos tile) in
  let y = Coord.get_y (Tile.get_pos tile) in
  match x,y with
    | (x,y) when (x < 41 && x > 0) && (y < 41 && y > 0) ->
      let top_tile = tile_by_pos (Coord.create x (y-1)) map in
      let upper_right_tile = tile_by_pos (Coord.create (x+1) (y-1)) map in
      let lower_right_tile = tile_by_pos (Coord.create (x+1) y) map in
      let bottom_tile = tile_by_pos (Coord.create x (y+1)) map in
      let lower_left_tile = tile_by_pos (Coord.create (x-1) y) map in
      let upper_left_tile = tile_by_pos (Coord.create (x-1) (y-1)) map in
      [top_tile;upper_right_tile;lower_right_tile;bottom_tile;lower_left_tile;upper_left_tile]
    | (x,y) when (x =41) && (y < 41 && y > 0) ->
      let top_tile = tile_by_pos (Coord.create x (y-1)) map in
      let bottom_tile = tile_by_pos (Coord.create x (y+1)) map in
      let lower_left_tile = tile_by_pos (Coord.create (x-1) y) map in
      let upper_left_tile = tile_by_pos (Coord.create (x-1) (y-1)) map in
      [top_tile;bottom_tile;lower_left_tile;upper_left_tile]
    | (x,y) when (x = 0) && (y < 41 && y > 0) ->
      let top_tile = tile_by_pos (Coord.create x (y-1)) map in
      let upper_right_tile = tile_by_pos (Coord.create (x+1) (y-1)) map in
      let lower_right_tile = tile_by_pos (Coord.create (x+1) y) map in
      let bottom_tile = tile_by_pos (Coord.create x (y+1)) map in
      [top_tile;upper_right_tile;lower_right_tile;bottom_tile]
    | (x,y) when (x < 41 && x > 0) && (y = 41) ->
      let top_tile = tile_by_pos (Coord.create x (y-1)) map in
      let upper_right_tile = tile_by_pos (Coord.create (x+1) (y-1)) map in
      let lower_right_tile = tile_by_pos (Coord.create (x+1) y) map in
      let lower_left_tile = tile_by_pos (Coord.create (x-1) y) map in
      let upper_left_tile = tile_by_pos (Coord.create (x-1) (y-1)) map in
      if x mod 2 = 0
      then [top_tile;upper_right_tile;upper_left_tile]
      else [upper_left_tile;top_tile;upper_right_tile;lower_left_tile;lower_right_tile]
    | (x,y) when (x < 41 && x > 0) && (y = 0) ->
      let upper_right_tile = tile_by_pos (Coord.create (x+1) (y-1)) map in
      let lower_right_tile = tile_by_pos (Coord.create (x+1) y) map in
      let bottom_tile = tile_by_pos (Coord.create x (y+1)) map in
      let lower_left_tile = tile_by_pos (Coord.create (x-1) y) map in
      let upper_left_tile = tile_by_pos (Coord.create (x-1) (y-1)) map in
      if x mod 2 = 0
      then [lower_right_tile;bottom_tile;lower_left_tile]
      else [upper_right_tile;lower_right_tile;bottom_tile;lower_left_tile;upper_left_tile]
    | (x,y) when (x = 0  && y = 0) ->
      let lower_right_tile = tile_by_pos (Coord.create (x+1) y) map in
      let bottom_tile = tile_by_pos (Coord.create x (y+1)) map in
      [lower_right_tile;bottom_tile]
    | (x,y) when (x = 41 && y = 0) ->
      let bottom_tile = tile_by_pos (Coord.create x (y+1)) map in
      let lower_left_tile = tile_by_pos (Coord.create (x-1) y) map in
      let upper_left_tile = tile_by_pos (Coord.create (x-1) (y-1)) map in
      [bottom_tile;lower_left_tile;upper_left_tile]
    | (x,y) when (x = 41 && y = 41) ->
      let top_tile = tile_by_pos (Coord.create x (y-1)) map in
      let upper_left_tile = tile_by_pos (Coord.create (x-1) (y-1)) map in
      [top_tile;upper_left_tile]
    | (x,y) when (x = 0 && y = 41) ->
      let top_tile = tile_by_pos (Coord.create x (y-1)) map in
      let upper_right_tile = tile_by_pos (Coord.create (x+1) (y-1)) map in
      let lower_right_tile = tile_by_pos (Coord.create (x+1) y) map in
      [top_tile;upper_right_tile;lower_right_tile]
    | _ -> raise (Critical ("Mapp.ml", "get_adjacent_tiles", "Idk"))


(* map generation *)
let generate width height =
  Random.self_init ();
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

let set_tile tile map =
  let arr_list = List.map Array.of_list map in
  let arr_list = Array.of_list arr_list in
  let c = Tile.get_pos tile in
  let x,y = (Coord.get_x c, Coord.get_y c) in
  let row = Array.get arr_list y in
  row.(x) <- tile; arr_list.(y) <- row;
  let arr_lst = Array.map Array.to_list arr_list in
  Array.to_list arr_lst

let rec get_random_tile map =
  Random.self_init ();
  let x,y = (Random.int (List.length map), Random.int (List.length map)) in
  let row = List.nth map y in
  let tile = List.nth row x in
  if Tile.has_building_restriction tile
  then get_random_tile map
  else tile

let rec get_nearest_available_tile tile map =
  if Tile.get_entity tile = None then tile else
  let rec check_surrounding tiles =
    match tiles with
    | [] -> None
    | h::t -> (
      let entity = Tile.get_entity h in
      match entity with
      | Some x -> Some h
      | None -> check_surrounding t
    ) in
  let tiles = get_adjacent_tiles map tile in
  let nearest = check_surrounding tiles in
  match nearest with
  | None -> (match tiles with
            | [] -> raise (Critical ("Mapp.ml",
                                    "get_nearest_available_tile",
                                    "No tiles found"))
            | h::t -> get_nearest_available_tile h map)
  | Some tile -> tile
