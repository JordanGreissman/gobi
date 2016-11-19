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

let create ~name ~descr ~town_hall_tile = {
  name = name;
  descr = descr;
  town_hall = Tile.place_hub
    ~name: "Town Hall"
    ~descr: "The Town Hall" (* TODO *)
    ~starting_entity: None
    ~production:            (* TODO *)
    ~production_rate: 1.0   (* TODO *)
    ~allowed_roles:         (* TODO *)
    ~def: 1000              (* TODO *)
    ~tile: town_hall_tile;
  tiles = [town_hall];
}
