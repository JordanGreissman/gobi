open Hub
open Tile


type t = {
	name: string;
	town_hall: hub;
	tiles: tile list;
}

let create ~name ~town_hall_tile = 
	{
		name = name;
		town_hall = Hub.create "town hall" None;
		tiles = [tile];
		hubs = [town_hall];
	}
