open Tile

type role = {
	description: string;
	number_of_turns: int;
	hub_name: string;
}

(** creates an entity type with a description, cost of creation in turn number, 
  * and the type of hub the role is for (represented via string) *)
let create_role description number_of_turns hub_name =
	{
		description = description;
		number_of_turns = number_of_turns;
		hub_name = hub_name;
	}

type t = {
	role: role;
	power: int * int;
	tile: tile;
}

(** Create an entity with a role, attack and defense values, and tile *)
let create_entity role attack defense tile = 
	{
		role = role;
		power = (attack, defense);
		tile = tile;
	}

(** Return role of entity *)
let get_role entity = entity.role

(** Get attack power level of entity *)
let get_attack entity = 
	let (attack , _ ) = entity.power in attack

(** Get defense power level of entity *)
let get_defense entity = 
	let (_ , defense) = entity.power in defense

(** Get total power level of entity, attack + defense *)
let get_total_power entity = 
	let (attack, defense) = entity.power in attack + defense

(** Increase / decrease the attack value of a unit, using + / - values. 
  * This affects total power levels *)
let set_attack amount entity =
	(Entity.get_attack entity + amount, Entity.get_defense entity)

(** Increase / decrease the defense value of a unit, using + / - values. 
  * This affects total power levels *)
let set_defense amount entity =
	(Entity.get_attack entity, Entity.get_defense entity + amount)

(** Return an entity with the tile changed *)
let set_tile tile entity = 
	Entity.(create_entity 
		entity.role (get_attack entity) (get_defense entity) tile)

