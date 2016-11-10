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

(** creates an entity type with a description, cost to create in turns, and
  * assigned hub *)
val create_role : string -> int -> Hub.t -> role

(** Create an entity with a certain power level, starting at a cluster's town hall
  * hub *)
val create : role -> int -> int -> Tile.t -> Hub.t option -> t

(** Increase / decrease the attack value of a unit, using + / - values. 
  * This affects total power levels *)
val change_attack : int -> t -> t

(** Increase / decrease the defense value of a unit, using + / - values. 
  * This affects total power levels *)
val change_defense : int -> t -> t

(** Move a unit to a new tile, affecting both structures *)
val move_to_tile : Tile.t -> t -> t

(** Move a unit to a new hub, affecting borth structures and hub production *)
val move_to_hub : Hub.t -> t -> t

(** Returns the attack value of the entity *)
val attack : t -> int

(** Returns the defense value of the entity *)
val defend : t -> int
