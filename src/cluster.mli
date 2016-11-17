(* the cluster type will be a record containing the following fields:
 * name: string;
 * town_hall: hub;
 * tiles: tile list;
 * hubs: hub list;
 *)
(** A cluster is a collection of tiles, all of which contain hubs ("are settled") *)
type t

(** creates a new cluster based on existing units on a settled tile *)
val create : Tile.t -> t

