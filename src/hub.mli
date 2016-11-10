(* the hub type will be a record containing the following types:)
 *  name: string;
 *  production_type: string;
 *  production_amount: int;
 *  entities: entity list;
 *  cluster: cluster;
 *  tile: tile;
 *)
(** the type of a hub *)
type t

(** Returns a new hub with a name and production_type string on a 
  * certain tile and cluster and adds it to the cluster *)
val create : string -> string -> Cluster.t -> Tile.t -> t

(** Returns a new hub based on parameters and removes it from the cluster *)
val remove : t -> t list

(** Change the multiplier for the production output *)
val change_production_amount : int -> t

(** Add entities to a hub, affecting production *)
val add_entities : Entity.t list -> t

(** Remove entities to a hub, affecting production *)
val remove_entities : Entity.t list -> t
