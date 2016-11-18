(** the type of an entity *)
type t

(** the different roles entities can have *)
type role

(** creates an entity type with a name & description (string), 
  * cost of creation through a turn number (int) *)
val create_role : string -> string -> int -> role

(** Create an entity with a role, attack and defense values, and 
  * coordinate value *)
val create_entity : role -> int -> int -> Coordinate.t -> t

(** Return role of entity *)
val get_role : t -> role

(** Get attack power level of entity *)
val get_attack : t -> int * int

(** Get defense power level of entity *)
val get_defense : t -> int

(** Get total power level of entity, attack + defense *)
val get_total_power : t -> int

(** Increase / decrease the attack value of a unit, using + / - values. 
  * This affects total power levels *)
val set_attack : int -> t -> t

(** Increase / decrease the defense value of a unit, using + / - values. 
  * This affects total power levels *)
val set_defense : int -> t -> t

(** Returns the coordinate representing the entity's position *)
val get_pos : t -> coordinate

(** Returns an entity with a new coordinate representing the entity's position *)
val set_pos : coordinate -> t -> t



