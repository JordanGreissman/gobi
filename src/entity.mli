open Hub
open Tile

module type Entity = struct 

	type t_type = {
		description: string;
		number_of_turns: int;
		hub: hub;
	}

	(* creates an entity type with a description, cost to create 
	 * in turns, and assigned hub *)
	val entity_type : string -> int -> hub -> t_type

	type t = {
		entity_type: t_type;
		power_level: (int, int);
		tile: tile;
		hub: hub option;
	}

	(* Create a unit with a certain power level, starting at a cluster's town hall
	 * hub *)
	val create_unit : t_type -> power_level -> tile -> hub option -> t

	(* Increase / decrease the attack value of a unit, using + / - values. 
	 * This affects total power levels *)
	val change_attack : t -> int -> t

	(* Increase / decrease the defense value of a unit, using + / - values. 
	 * This affects total power levels *)
	val change_defense : t -> int -> t

	(* Move a unit to a new tile, affecting both structures *)
	val move_to_tile : t -> tile -> t

	(* Move a unit to a new hub, affecting borth structures and hub production *)
	val move_to_hub : t -> hub -> t

	(* Returns the attack value of the entity *)
	val attack : t -> int

	(* Returns the defense value of the entity *)
	val defend : t -> int

end