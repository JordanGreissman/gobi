(** A cluster is a collection of tiles, all of which contain
	* hubs ("are settled") *)
type t

(** creates a new cluster with a name on a settled tile *)
val create : name:string -> descr:string -> town_hall_tile:Tile.t ->
	hub_role_list:Hub.role list -> map:Mapp.t -> t * Mapp.t

(* Returns the cluster's town hall *)
val get_town_hall : t -> Tile.t

