open Hub
open Tile
open Entity

type t = {
	name: string;
	town_hall: hub;
	tiles: tile list;
	hubs: hub list;
}

let create name tile = 
	{
		name = name;
		town_hall = set_finished Hub.create None None [] 100;
		tiles = [tile];
		hubs = [town_hall];
	}
