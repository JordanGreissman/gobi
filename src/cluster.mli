type tile = Tile.t

(** A cluster is a collection of tiles, all of which contain
	* hubs ("are settled") *)
type t

(** Creates a new cluster on a settled tile with a name and description 
  * (string), a tile to place a town hall on (tile), a master list of hub 
  * roles for the town hall (Hub.role list), and the map of the game (map).
  * returns the new cluster and the new map in a tuple respectively *)
val create : name:string -> descr:string -> town_hall_tile:Tile.t ->
	hub_role_list:Hub.role list -> map:Mapp.t -> t * Mapp.t

(** Returns a valid cluster's town hall *)
val get_town_hall : t -> tile

(** Adds a hub to a cluster, finding the nearest one based on hub coord.,
 * returning the cluster with the new tile w/ hub on it *)
val add_hub : t list -> Mapp.t -> Hub.t -> t list

(** Applies a function for tiles on every tile in a cluster. Acc should be [].
  * Returns cluster with new tile list *)
val tile_map : (tile -> tile) -> tile list -> t -> t

(** Returns valid cluster with an updated tile list with entity added 
  * to hub. Raises BadInvariant if hub doesn't exist in cluster. *)
val add_entity_to_hub : Entity.t -> Hub.t -> t -> t

(** Returns the tiles of the valid cluster *)
val get_tiles : t -> tile list

