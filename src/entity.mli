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

(* getters and setters *)

val get_attack : t -> int
val set_attack : int -> t -> t

val get_defense : t -> int
val set_defense : int -> t -> t

val get_pos : t -> Coord.t
val set_pos : Coord.t -> t -> t

(** Get total power level of entity, attack + defense *)
val get_total_power : t -> int

val get_role : t -> role
