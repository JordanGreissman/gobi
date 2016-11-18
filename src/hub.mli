(** the type of a hub *)
type t

(** Create and return a hub.
  * [starting_entity] is an entity that will automatically be consumed by the
  *   new hub when it is finished being built, if such an entity exists.
  *   Typically this is the first entity to start construction of the hub.
  * [production] is the type of resource that this hub produces. If this hub only
  *   produces entities, than [production] should be set to [None].
  * [production_amt] is the base production rate of the hub (the number of
  *   resource units produced per turn when the hub only contains one entity).
  *   If this hub only produces entities, then [production_amt] has the same
  *   meaning, but it is understood that it represents the production rate of
  *   entities, not resource units.
  * [allowed_roles] is a list of the types of entities that are allowed inside
  *   this hub. For example, only farmers are allowed inside a farm hub (no other
  *   role types make sense), so for a farm hub, [allowed_roles = ["farmer"]].
  * [def] is the defense level of the hub. Hubs have a defense level but no
  *   attack level because while it is possible for any hub to be attacked by an
  *   entity, hubs themselves cannot attack.
  *)
val create :
  name:string ->
  descr:string ->
  starting_entity:Entity.t option ->
  production:Resource.t option ->
  production_amt:int ->
  allowed_roles:Entity.role list ->
  def:int ->
  t

val describe : t -> string

(** Add an entity to a hub. When this is done, the entity increases the
  * production rate of the hub by a set amount, and the entity cannot be
  * reclaimed.
  *)
val add_entity : Entity.t -> t -> t

(* getters and setters *)

val get_name : t -> string

(** is the construction of this hub finished? *)
val is_finished : t -> bool

(** mark this hub as finished (construction is complete) *)
val set_finished : t -> t

(** Returns the production resource of the hub argument. If this hub only
  * produces entities, return [None].
  *)
val get_resource : t -> Resource.t option

val get_production_rate : t -> float

val get_allowed_roles : t -> Entity.role list

val get_defense : t -> int
val set_defense : int -> t -> t
