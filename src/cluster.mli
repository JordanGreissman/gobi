type tile = Tile.t

(** A cluster is a collection of tiles, all of which contain
	* hubs ("are settled") *)
type t

(** creates a new cluster with a name on a settled tile *)
val create : name:string -> descr:string -> town_hall_tile:Tile.t ->
	hub_role_list:Hub.role list -> map:Mapp.t -> t * Mapp.t

(* Returns the cluster's town hall *)
val get_town_hall : t -> tile

(* Adds a hub to a cluster, finding the nearest one based on hub coord.,
 * returning the cluster with the new tile w/ hub on it *)
val add_hub : t list -> Mapp.t -> Hub.t -> t list

(** Applies a function for tiles on every tile in a cluster. Acc should be [].
  * Returns cluster with new tile list *)
val tile_map : (tile -> tile) -> tile list -> t -> t

(* Returns cluster with an updated tile list with entity added to hub *)
val add_entity_to_hub : Entity.t -> Hub.t -> t -> t

val get_tiles : t -> tile list

