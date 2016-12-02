(** the type of a hub role. Hub roles are just another name for hub types (e.g.
  * post office, mill, armory, etc.) because it would be confusing to use the
  * word "type" in two different ways at once.
  *)
type role

type coord = Coord.t

(** the type of a hub. This type represents a specific instance of a hub, which
  * has a location, production levels, etc., and should not be conflated with
  * the [role] type, described below.
  *)
type t = {
  role: role;
  (* the number of production units this hub generates every turn. This number
   * can be increased by adding entities to the hub *)
  production_rate: int;
  (* the defense of this hub (for when it is attacked by entities)
   * NOTE that the defense is allowed to be negative! It is the responsibility
   * of the caller to check the updated defense value after changing it *)
  def: int;
  (* the position of this hub (in rectangular map coordinates) *)
  pos: coord;
}

(** the production type of a hub. Hubs can produce either resources or entities *)
type production =
  | Resource of Resource.t
  | Entity of Entity.role

val prod_to_resource : production -> Resource.t

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
  production_rate : int ->
  def : int ->
  pos : Coord.t ->
  t

(** Create and return a hub role.
  * [name] is the name of the hub role (e.g. "Post Office", "Mill", etc.)
  * [descr] is a description of this hub type and its capabilities that would
  *   be useful to the player if they wanted to know more about this hub role.
  * [cost_to_make] is the number of turns after initiating construction of this
  *   hub type that the hub type will be ready for use.
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

(** Faciliate going from JSON to a hub role. Hold on to your hats.
  * [name] is the name of the role
  * [description] is a description of the role that the player would find useful
  *   if they wanted to know more about the role and its capabilities
  * [built_by] is the entity role that can build a hub of this role. This string
  *   should therefore be a valid entity role name
  * [default_def] is the default defense (AKA health) of hubs of this role
  * [cost_to_make] is the number of turns after construction of a hub of this
  *   role is started that the hub will be ready for use
  * [resource] is the resource this hub produces, if any. This argument should
  *   therefore be a string representing a valid resource
  * [amount] is the amount of [resource] that hubs of this role produce every
  *   turn by default (when there are no entities increasing the production rate
  *   of the hub)
  * [entities] is the list of entity roles that hubs of this role can produce
  * [entity_role_list] is the master list of all the entity roles that exist in
  *   the game
  *)
val extract_to_role :
  name:string ->
  descr:string ->
  built_by:string ->
  default_def:int ->
  cost_to_make:int ->
  resource:string ->
  amount:int ->
  entities:string list ->
  entity_role_list:Entity.role list ->
  role

(* Return a role matching the string. "all" returns role_list. Otherwise, Illegal exception *)
val find_role : string -> role list -> role list

val tick_cost : t -> t

val is_done : t -> bool

(* [t] getters and setters *)

val get_role : t -> role

val get_production_rate : t -> int

(* change hub's production rate by an integer *)
val change_production_rate : int -> t -> t

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

val get_role_allowed_roles : role -> Entity.role list
val get_role_production : role -> production list
val get_role_default_production_rate : role -> int
val get_role_default_defense : role -> int

(* convenience functions *)
val get_name : t -> string
val get_cost_to_make : t -> int
val get_art : t -> Art.t
val get_allowed_roles : t -> Entity.role list
val get_production : t -> production list
val get_default_production_rate : t -> int
val get_default_defense : t -> int

(* add production to hub's role, return hub *)
val addto_role_production : production list -> t -> t

