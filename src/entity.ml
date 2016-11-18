type coordinate = Coord.t

type role = {
	name: string;
	description: string;
	number_of_turns: int;
}

type t = {
  role: role;
  power: int*int;
  position: coordinate
}

(** Create an entity with a role, attack and defense values, and coordinate *)
let create ~role ~atk ~def ~pos = 
	{
		role = role;
		power = (atk, def);
		position = pos
	}

(** creates an entity type with a description (string), 
  * cost of creation through a turn number (int) *)
let create_role ~name ~descr ~cost_to_make =
	{
		name = name;
		description = descr;
		number_of_turns = cost_to_make
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
  { entity with power=(get_attack entity + amount, get_defense entity) }

(** Increase / decrease the defense value of a unit, using + / - values. 
  * This affects total power levels *)
let set_defense amount entity =
	{ entity with power=(get_attack entity, get_defense entity + amount) }

(** Returns the coordinate representing the entity's position *)
let get_pos entity = entity.position

(** Returns an entity with a new coordinate representing the entity's position *)
let set_pos position entity = 
	{ entity with position = position}

let describe entity =
  failwith "Unimplemented"
