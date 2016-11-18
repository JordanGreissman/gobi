(** A cluster is a collection of tiles, all of which contain hubs ("are settled") *)
type t

(** creates a new cluster with a name on a settled tile *)
val create : name:string -> town_hall_tile:Tile.t -> t

