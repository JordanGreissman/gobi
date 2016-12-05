open Exception

type tile = Tile.t

type t = {
  (* the name of this cluster (e.g. "New York", "Paris", etc.) *)
  name: string;
  (* a description of this cluster that would be useful to the player if they
   * wanted to know more about this cluster *)
  descr: string;
  (* the tile that contains this cluster's town hall *)
  town_hall: tile;
  (* a list of all the tiles that comprise this cluster (they should all be
   * "settled", which means they have hubs on them) *)
  tiles: tile list;
}

let create ~name ~descr ~town_hall_tile ~hub_role_list ~map =

  let town_hall_hub = List.hd (Hub.find_role "town_hall" hub_role_list) in
  let town_hall = Tile.place_hub town_hall_hub None town_hall_tile in
  let map = Mapp.set_tile town_hall map in
  ({
    name = name;
    descr = descr;
    town_hall = town_hall;
    tiles = [town_hall];
  }, map)

let get_town_hall cluster =
  cluster.town_hall

let add_hub cluster_list map hub =

  let hub_pos = Hub.get_position hub in

  let tuple_compare t1 t2 = compare (snd t1) (snd t2) in

  let distance_to town_hall =
    let x_del = Coord.get_x hub_pos - Coord.get_x town_hall in
    let y_del = Coord.get_y hub_pos - Coord.get_y town_hall in
      ((float_of_int x_del)**2.0 +. (float_of_int y_del)**2.0)**0.5
  in

  let fold_func acc cluster =
    acc@[distance_to (Tile.get_pos (get_town_hall cluster))] in

  let distance_list = List.fold_left fold_func [] cluster_list in
  let cluster = fst (List.hd (List.sort tuple_compare
      (List.combine cluster_list distance_list))) in

  let new_hub_tile = Mapp.tile_by_pos hub_pos map in
  let new_cluster =
    { cluster with tiles = new_hub_tile::cluster.tiles } in
  let new_cluster_name = new_cluster.name in
  let unchanged_clusters =
    List.filter (fun x -> x.name <> new_cluster_name) cluster_list in
  new_cluster::unchanged_clusters

let rec tile_map tile_func acc cluster = match cluster.tiles with
  | [] -> { cluster with tiles = acc }
  | tile::lst ->
    tile_map tile_func (acc@[tile_func tile]) { cluster with tiles = lst}

let rec add_entity_to_hub entity hub cluster =
  let tile_func tile = (
    match Tile.get_hub tile with
      | Some tile_hub ->
        if tile_hub = hub then
          let new_hub = { tile_hub with
            production_rate = Hub.get_production_rate tile_hub + 1 }
          in Tile.set_hub tile (Some new_hub)
        else tile
      | _ ->
        raise (BadInvariant (
            "cluster",
            "add_entity_to_hub",
            "Tile doesn't have hub, precondition violated"))
    ) in tile_map (tile_func) [] cluster

let get_tiles t = t.tiles
