open Hub
open Tile
open Entity

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

(** Add entity to a hub, returning the new hub and civ in a tuple.
  * Raise Illegal if entity role isn't allowed in the hub *)
let add_entity_to_hub entity hub civ =
  if List.mem (Entity.get_role entity) hub.allowed_roles
  then 
    let new_e_list = List.filter (fun e -> not e = entity) civ.entities in
    let new_civ = { civ with entities = new_e_list } in
    let new_hub = { hub with production_rate = hub.production_rate + 1 } in
      (hub, civ)
  else raise (Exception.Illegal "This entity has the wrong role for the hub"); hub 
