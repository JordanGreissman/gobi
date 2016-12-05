(** the type of an entity *)
type t

(** the different roles entities can have; e.g. lumberjack, farmer, etc. *)
type role

(** Faciliate going from JSON to role. Respectively takes
  * the role name and description (strings)
  * the cost to make, attack, and defense values (int),
  * and the number of actions (int) *)
val extract_to_role : string -> string -> string ->
                      int -> int -> int -> int -> role

(** Returns the role with the name of a certain string, exception 
 * Illegal otherwise *)
val find_role: string -> role list -> role

(** Create and return an entity. An entity has a role, an attack level, a defense
  * level, and a position.
  *)
val create : role:role -> ?atk:int -> ?def:int -> pos:Coord.t -> id:int -> t

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

(** Returns the description of a valid entity *)
val describe : t -> string

(** Returns the description of the role of a valid entity *)
val describe_role : role -> string

(** Decreases the cost to make a role by 1 *)
val tick_cost : t -> t

(** Returns true if an entity has no cost to make *)
val is_done : t -> bool

(** Returns the role of a valid entity *)
val get_role : t -> role

(** Returns the attack value of a valid entity *)
val get_attack : t -> int

(** Changes the attack level of a valid entity by a relative amount 
  * (positive values increase the attack, negative values decrease 
  * the attack). Returns entity. *)
val change_attack : int -> t -> t

(** Returns the defensive value of a valid entity *)
val get_defense : t -> int

(** Changes the defense level of an entity by a relative amount 
  * (positive values increase the defense, negative values decrease 
  * the defense). Returns entity. *)
val change_defense : int -> t -> t

(** Get total power level of entity, attack + defense *)
val get_total_power : t -> int

(** Returns the coordinate representing the valid entity's position *)
val get_pos : t -> Coord.t

(** Returns an entity with a new coordinate representing the entity's 
  * position . Returns entity. *)
val set_pos : Coord.t -> t -> t

(** Returns the name of the role of a valid entity *)
val get_role_name : role -> string

(** Returns the cost to make of a role of a valid entity *)
val get_role_cost_to_make : role -> int

(** Returns the art of a valid entity *)
val get_role_art : role -> Art.t

(** Returns true if the role has costs nothing to make *)
val is_role_unlocked : role -> bool

(** Returns role if [is_role_unlocked r] is true, marked accordingly *)
val unlock_role : role -> role

(** Returns the default power of a role, (attack, defense), 
  * of a valid entity *)
val get_role_default_power : role -> int*int

(* Returns the actions of a valid entity *)
val get_actions : t -> int

(** Sets the ctions of a valid entity. Returns entity. *)
val set_actions : int -> t -> t

(** Returns the actions used of a valid entity *)
val get_actions_used: t -> int

(** Sets the actions used of a valid entity *)
val set_actions_used: t -> int -> t

(** Returns the name of a valid entity *)
val get_name : t -> string

(** Returns the cost to make of a valid entity *)
val get_cost_to_make : t -> int

(** Returns the art of a valid entity *)
val get_art : t -> Art.t

(** Returns the id of a valid entity *)
val get_id : t -> int

(** Sets the id of a valid entity. Returns entity. *)
val set_id : int -> t -> t
