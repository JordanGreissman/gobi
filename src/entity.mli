(** the type of an entity *)
type t

(** the different roles entities can have; e.g. lumberjack, farmer, etc. *)
type role

(* Faciliate going from JSON to role. Respectively takes
   * the role name and description (strings)
   * the cost to make, attack, and defense values (int),
   * and the number of actions (int) *)
val extract_to_role : string -> string -> string ->
                      int -> int -> int -> int -> role

(* Returns the role with the name of a certain string, failwith otherwise *)
val find_role : string -> role list -> role

(** Create and return an entity. An entity has a role, an attack level, a defense
  * level, and a position.
  *)
val create : role:role -> ?atk:int -> ?def:int -> pos:Coord.t -> t

(** Create and return a role.
  * [name] is the name of this entity role (e.g. "Lumberjack", "Farmer", etc.)
  * [descr] is a description of this entity type that would be useful to the
  *   player if they wanted to know more about this entity role.
  * [cost_to_make] is the number of turns after starting production of an entity
  *   of this role type that the entity will be available for use.
  * [unlocked] is whether entities of this role can be made. Some entities are
  *   initially locked, and are unlocked through research.
  *)
val create_role :
  name:string ->
  descr:string ->
  cost_to_make:int ->
  unlocked:bool ->
  actions:int ->
  default_power:int*int ->
  role

val describe : t -> string
val describe_role : role -> string

(* [t] getters and setters *)

val get_role : t -> role

val get_attack : t -> int

(** change the attack level of an entity by a relative amount (positive values
  * increase the attack, negative values decrease the attack, etc.).
  *)
val change_attack : int -> t -> t

val get_defense : t -> int

(** change the defense level of an entity by a relative amount (positive values
  * increase the defense, negative values decrease the defense, etc.).
  *)
val change_defense : int -> t -> t

(** Get total power level of entity, attack + defense *)
val get_total_power : t -> int

(** Returns the coordinate representing the entity's position *)
val get_pos : t -> Coord.t

(** Returns an entity with a new coordinate representing the entity's position *)
val set_pos : Coord.t -> t -> t

(* [role] getters and setters *)
val get_role_name : role -> string
val get_role_cost_to_make : role -> int
val get_role_art : role -> Art.t

val is_role_unlocked : role -> bool

(** [unlock_role r] is [r] where [is_role_unlocked r] is guaranteed to be true.
  *)
val unlock_role : role -> role

val get_role_default_power : role -> int*int

(* convenience functions *)
val get_actions : t -> int
val get_name : t -> string
val get_cost_to_make : t -> int
val get_art : t -> Art.t
