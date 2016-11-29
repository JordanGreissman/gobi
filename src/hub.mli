(** the type of a hub. This type represents a specific instance of a hub, which
  * has a location, production levels, etc., and should not be conflated with
  * the [role] type, described below.
  *)
type t

(** the type of a hub role. Hub roles are just another name for hub types (e.g.
  * post office, mill, armory, etc.) because it would be confusing to use the
  * word "type" in two different ways at once.
  *)
type role

(** the production type of a hub. Hubs can produce either resources or entities *)
type production =
  | Resource of Resource.t
  | Entity of Entity.role

(** Create and return a hub.
  * [role] is the hub role (i.e. the type of hub).
  * [production_rate] is the base production rate of the hub (the number of
  *   production units produced per turn when the hub only contains one entity).
  *   This is understood to be in terms of resource units if the hub produces
  *   resources, or entities if the hub produces entities.
  * [def] is the defense level of the hub. Hubs have a defense level but no
  *   attack level because while it is possible for any hub to be attacked by an
  *   entity, hubs themselves cannot attack.
  *)
val create :
  role : role ->
  production_rate : int list ->
  def : int ->
  pos : Coord.t ->
  t

(** Create and return a hub role.
  * [name] is the name of the hub role (e.g. "Post Office", "Mill", etc.)
  * [descr] is a description of this hub type and its capabilities that would
  *   be useful to the player if they wanted to know more about this hub role.
  * [cost_to_make] is the number of turns after initiating construction of this
  *   hub type that the hub type will be ready for use.
  * [unlocked] is whether the player is allowed to build hubs of this hub role.
  *   Some hub roles are initially locked, and are unlocked through research.
  * [allowed_roles] is a list of the types of entities that are allowed inside
  *   this hub role in order to increase its production. For example, only farmers
  *   are allowed inside a "Farm" hub (no other role types make sense), so for
  *   this hub role [allowed_roles = ["farmer"]].
  * [production] is the list of things that hubs of this hub role can produce.
  * [default_production_rate] is the production rate of hubs of this hub role
  *   when they contain 0 entities.
  * [default_def] is the starting defense of hubs of this hub type.
  *)
val create_role :
  name:string ->
  descr:string ->
  cost_to_make:int ->
  allowed_roles : Entity.role list ->
  production : production list ->
  default_def : int ->
  role

val describe : t -> string
val describe_role : role -> string

(* Faciliate going from JSON to a hub role. Hold on to your hats.
 * name, description (string)
 * built_by, a string that's a valid Entity role
 * default_def, an int that's the health or defense
 * cost_to_make, an int
 * resource, a string of a valid Resource
 * amount, an int
 * entities, a string list of valid roles that it produces
 * entity_role_list, (entity role list) the master list of all roles in the game
 *)
val extract_to_role : string -> string -> string -> int -> int -> string -> int -> string list -> role list -> role

(** Add an entity to a hub. When this is done, the entity increases the
  * production rate of the hub by a set amount, and the entity cannot be
  * reclaimed.
  *)
val add_entity : Entity.t -> t -> t

(* [t] getters and setters *)

val get_role : t -> role

(** is the construction of this hub finished? *)
val is_finished : t -> bool

(** mark this hub as finished (construction is complete) *)
val set_finished : t -> t

val get_production_rate : t -> int list

val get_defense : t -> int

(** change the defense of this hub by a relative amount (positive values increase
  * the defense, negative values decrease the defense, etc.).
  *)
val change_defense : int -> t -> t

val get_position : t -> Coord.t

(** [change_position delta h] is the hub whose new position is the hub's old
  * position plus [delta].)
  *)
val change_position : Coord.t -> t -> t

(* [role] getters and setters *)
val get_role_name : role -> string
val get_role_cost_to_make : role -> int
val get_role_art : role -> Art.t

val is_role_unlocked : role -> bool

(** [unlock_role r] is [r] where [is_role_unlocked r] is guaranteed to be [true].
  *)
val unlock_role : role -> role

val get_role_allowed_roles : role -> Entity.role list
val get_role_production : role -> production list
val get_role_default_production_rate : role -> int list
val get_role_default_defense : role -> int

(* convenience functions *)
val get_name : t -> string
val get_cost_to_make : t -> int
val get_art : t -> Art.t
val get_allowed_roles : t -> Entity.role list
val get_production : t -> production list
val get_default_production_rate : t -> int list
val get_default_defense : t -> int
