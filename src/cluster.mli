type tile = Tile.t

(** A cluster is a collection of tiles, all of which contain
	* hubs ("are settled") *)
type t

(** creates a new cluster with a name on a settled tile *)
val create : name:string -> descr:string -> town_hall_tile:Tile.t ->
	hub_role_list:Hub.role list -> map:Mapp.t -> t * Mapp.t

(* Returns cluster with an updated tile list with entity added to hub *)
val add_entity_to_hub : Entity.t -> Hub.t -> Tile.t list -> t -> t

(* Returns the cluster's town hall *)
val get_town_hall : t -> Tile.t

