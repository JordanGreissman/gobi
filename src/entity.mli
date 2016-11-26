(** the type of an entity *)
type t

(** the different roles entities can have; e.g. lumberjack, farmer, etc. *)
type role

(** Create and return an entity. An entity has a role, an attack level, a defense
  * level, and a position.
  *)
val create : role:role -> atk:int -> def:int -> pos:Coord.t -> t

(** Create and return a role.
  * [cost_to_make] is the number of turns after starting production of an entity
  * of this role type that the entity will be available for use.
  *)
val create_role : name:string -> descr:string -> cost_to_make:int -> role

val describe : t -> string

val describe_role : role -> string

(* getters and setters *)

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

(** Increase / decrease the attack value of a unit, using + / - values. 
  * This affects total power levels. Returns new entity *)
val change_attack : int -> t -> t

(** Increase / decrease the defense value of a unit, using + / - values. 
  * This affects total power levels. Returns new entity *)
val change_defense : int -> t -> t

(** Returns the coordinate representing the entity's position *)
val get_pos : t -> Coord.t

(** Returns an entity with a new coordinate representing the entity's position *)
val set_pos : Coord.t -> t -> t

val get_role : t -> role
