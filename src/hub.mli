(** the type of a hub *)
type t

(* TODO API:
 *   - type [role] is a string which uniquely identifies a role. Exposed (the type, not its definition).
 *   - type [role_info] is used internally to store info about a role
 *   - val [roles] is a internal master list of (role*role_info)
 *   - getters for every field
 *   - setters only as necessary (right now only for unlock)
 *   - do the same for entity!
 *)
(* TODO clean this whole thing up and make sure you and Matt are on the same page *)
(** a hub role (answers the question "What type of hub is it?") *)
type role

(** add a new role *)
val create_role : name:string -> descr:string -> unlocked:bool -> unit

(** set a role as having been unlocked *)
val unlock_role : role -> unit

(** the production type of a hub. Hubs can produce either resources or entities *)
type production =
  | Resource of Resource.t
  | Entity of Entity.role

(** Create and return a hub.
  * [starting_entity] is an entity that will automatically be consumed by the
  *   new hub when it is finished being built, if such an entity exists.
  *   Typically this is the first entity to start construction of the hub.
  * [production] is the production type of this hub.
  * [production_rate] is the base production rate of the hub (the number of
  *   production units produced per turn when the hub only contains one entity).
  *   This is understood to be in terms of resource units if the hub produces
  *   resources, or entities if the hub produces entities.
  * [allowed_roles] is a list of the types of entities that are allowed inside
  *   this hub. For example, only farmers are allowed inside a farm hub (no other
  *   role types make sense), so for a farm hub, [allowed_roles = ["farmer"]].
  * [def] is the defense level of the hub. Hubs have a defense level but no
  *   attack level because while it is possible for any hub to be attacked by an
  *   entity, hubs themselves cannot attack.
  *)
val create :
  name : string ->
  descr : string ->
  starting_entity : Entity.t option ->
  (* TODO: Can a hub produce multiple types of resources/entities? If so, then
   * this should be a [production list] instead, and [production_rate] should be
   * a [float list] *)
  production : production ->
  production_rate : float ->
  allowed_roles : Entity.role list ->
  def : int ->
  pos : Coord.t ->
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

val get_production : t -> production

val get_production_rate : t -> float

val get_allowed_roles : t -> Entity.role list

val get_defense : t -> int

(** change the defense of this hub by a relative amount (positive values increase
  * the defense, negative values decrease the defense, etc.).
  *)
val change_defense : int -> t -> t
