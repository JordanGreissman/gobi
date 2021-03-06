type coordinate = Coord.t
type art = Art.t

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
  (* the ascii art for an entity of this role *)
  art: art;
  (* whether the entity role has been unlocked and can be made *)
  unlocked: bool;
  (* the number of actions an entity has *)
  actions: int;
  (* the default (starting) power of entities of this entity role *)
  default_power: int*int;
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
  (* unique id for each entity*)
  id: int;
  (*keeps count of how many actions they used*)
  actions_used: int;
}

let rec find_role role_str role_list =
  match role_list with
  | [] -> raise (Exception.Illegal (role_str^" is not a valid role."))
  | h::t -> if h.name = role_str then h
    else find_role role_str t

let create ~role ?atk ?def ~pos ~id =
  let attack = match atk with
    | Some a -> a
    | None -> fst role.default_power in
  let defense = match def with
    | Some d -> d
    | None -> snd role.default_power in
  {
    role         = role;
    power        = (attack,defense);
    pos          = pos;
    id           = id;
    actions_used = 0;
  }

let create_role ~name ~descr ~cost_to_make ~unlocked ~actions
  ~default_power = {
    name          = name;
    descr         = descr;
    cost_to_make  = cost_to_make;
    art           = Art.load name;
    unlocked      = unlocked;
    actions       = actions;
    default_power = default_power;
}

let extract_to_role name descr requires cost_to_make attack defense actions =
  let unlocked = (requires = "") in
  let default_power = (attack, defense) in
  create_role name descr cost_to_make unlocked actions default_power

let describe e =
  Printf.sprintf
    "This is a %s which has used %d/%d moves"
    e.role.name
    e.actions_used
    e.role.actions

let describe_role r =
  r.descr

let tick_cost t =
  {t with role = {t.role with cost_to_make = t.role.cost_to_make - 1}}

let is_done t =
  t.role.cost_to_make = 0

let get_actions_used entity = entity.actions_used

let set_actions_used entity x = {entity with actions_used = x}

let get_role entity = entity.role

let get_attack e = fst e.power

let get_defense e = snd e.power

let change_attack amt e = { e with power=(get_attack e + amt,get_defense e) }

let change_defense amt e = { e with power=(get_attack e,get_defense e + amt) }

let get_total_power e =
  let (attack, defense) = e.power in
  attack + defense

let get_pos e = e.pos

let set_pos position entity = { entity with pos = position }

let get_role_name r = r.name
let get_role_cost_to_make r = r.cost_to_make
let get_role_art r = r.art

let is_role_unlocked r = r.unlocked
let unlock_role r = { r with unlocked = true }

let get_role_default_power r = r.default_power

let set_actions x t = {t with role = {t.role with actions = x}}

let get_actions e = e.role.actions
let get_name e = e.role.name
let get_cost_to_make e = e.role.cost_to_make
let get_art e = e.role.art

let get_id e = e.id
let set_id id e = { e with id = id }
