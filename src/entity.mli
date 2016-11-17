(* the entity type will be a record containing the following types:
 *  entity_type: t_type;
 *  power_level: (int, int);
 *  tile: tile;
 *  hub: hub option;
 *)
(** the type of an entity *)
type t

(* the role type will be a record containing the following types:
 *  description: string;
 *  number_of_turns: int;
 *  hub: hub;
 *)
(** the different roles entities can have *)
type role

(** creates an entity type with a description, cost of creation in turn number, 
  * and the type of hub the role is for (represented via string) *)
val create_role : string -> int -> string_entiti -> role

(** Create an entity with a role, attack and defense values, and tile *)
val create_entity : role -> int -> int -> Tile.t -> t

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

(** Return an entity with the tile changed *)
val set_tile : Tile.t -> t -> t



