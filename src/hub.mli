(* the hub type will be a record containing the following types:)
 *  name: string;
 *  resource: resource option
 *  entities: entity list;
 *  defense: int
 *)
(** the type of a hub *)
type t

(** Returns a new hub with a name and production_type string on a 
  * certain tile and cluster and adds it to the cluster. Default
  * production amount is 0, with no entities *)
val create : string -> entity -> resource option -> role list -> int -> t

val is_finished : t -> bool

val set_finished : t -> t

(** Returns resource of hub *)
val get_resource : t -> resource

(** Returns the hub with a new resource passed in *)
val set_resource : resource -> t -> t

(** Add entity to a hub, returning the new hub *)
val add_entity : Entity.t -> t -> t

(** Remove entity to a hub, returning the new hub *)
val remove_entity : Entity.t -> t-> t

(** Get defense value of hub *)
val get_defense : t -> int

(** Edit defense value of hub; pos. int to increase, 
  * neg. int to decrease; return new hub *)
val set_defense : int -> t -> t
