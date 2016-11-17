(* the cluster type will be a record containing the following fields:
 * name: string;
 * town_hall: hub;
 * tiles: tile list;
 * hubs: hub list;
 *)
(** the type of a cluster *)
type t

(** creates a new cluster with a name on a settled tile *)
val create : string -> Tile.t -> t

