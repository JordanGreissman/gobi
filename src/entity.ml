type coordinate = Coord.t

(** the different roles entities can have *)
type role = {
  (* the name of this role (e.g. "Farmer", "Soldier", etc.) *)
  name: string;
  (* a description of this role and its capabilities that would be useful to the
   * player if they wanted to know more about this role *)
  descr: string;
  (* the number of turns after starting production of an entity of this role type
   * that the entity will be available for use *)
  cost_to_make: int;
}

type t = {
  (* the type of entity (e.g. farmer, soldier, etc.) *)
  role: role;
  (* an (attack, defense) tuple. Attack is this entity's potential to do damage
   * to other entities, and defense is this entity's potential to prevent damage
   * being dealt to it from other entities *)
  power: int*int;
  (* this entity's current position on the map *)
  pos: coordinate;
}

let create ~role ~atk ~def ~pos = {
  role  = role;
  power = (atk, def);
  pos   = pos;
}

let create_role ~name ~descr ~cost_to_make = {
  name         = name;
  descr        = descr;
  cost_to_make = cost_to_make;
}

let describe e =
  failwith "Unimplemented"

let describe_role r =
  failwith "Unimplemented"

let get_attack e = fst e.power
 
let get_defense e = snd e.power

let change_attack amt e = { e with power=(get_attack e + amt,get_defense e) }

let change_defense amt e = { e with power=(get_attack e,get_defense e + amt) }

(* Get total power level of entity, attack + defense *)
let get_total_power e = 
  let (attack, defense) = e.power in
  attack + defense

let get_pos e = e.pos

(** Returns an entity with a new coordinate representing the entity's position *)
let set_pos position entity = { entity with pos = position }

let get_role entity = entity.role
