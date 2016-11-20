type entity = Entity.t
type role = Entity.role
type resource = Resource.t
type coord = Coord.t

type production =
  | Resource of resource
  | Entity of role

type t = {
  (* the name of the hub (e.g. "Mill", "Barracks", etc.) *)
  name: string;
  (* a description of the hub and its capabilities that would be useful to
   * the player if they wanted to know about the hub in detail *)
  descr: string;
  (* whether the hub is finished being built *)
  is_finished: bool;
  (* what this hub produces *)
  production: production;
  (* the number of production units this hub generates every turn. This number
   * can be increased by adding entities to the hub *)
  production_rate: float;
  (* the types of entities (roles) that are allowed to be consumed by this hub
   * in order to increase its production. E.g. only farmer entities should be
   * able to increase the production of a farm because soldiers and other entity
   * roles don't know how to farm well. *)
  allowed_roles: role list;
  (* the defense of this hub (for when it is attacked by entities)
   * NOTE that the defense is allowed to be negative! It is the responsibility
   * of the caller to check the updated defense value after changing it *)
  def: int;
  (* the position of this hub (in rectangular map coordinates) *)
  pos: coord;
}

let create ~name ~descr ~starting_entity ~production
           ~production_rate ~allowed_roles ~def ~pos =
{
  name            = name;
  descr           = descr;
  is_finished     = false;
  production      = production;
  production_rate = production_rate;
  allowed_roles   = allowed_roles;
  def             = def;
  pos             = pos;
}

let describe hub =
  failwith "Unimplemented"

(** Add entity to a hub, returning the new hub *)
let add_entity new_entity hub = 
  if List.mem (Entity.get_role new_entity) hub.allowed_roles
  then
    (* TODO: delete this entity *)
    (* TODO: by how much does the production rate increase for one entity? *)
    { hub with production_rate = hub.production_rate +. 1.0 }
  (* TODO: handle exceptions when bad stuff happens *)
  else hub

let get_name hub = hub.name

let is_finished hub = hub.is_finished

let set_finished hub = { hub with is_finished = true }

(** Remove entity to a hub, returning the new hub *)
let remove_entity old_entity hub = 
	let new_entity_list = 
		List.filter 
			(fun entity -> not (entity = old_entity))
		hub.entities in

	{ hub with entities = hub.entities @ entity	}

(** Get defense value of hub *)
let get_defense hub = hub.defense

(** Edit defense value of hub; pos. int to increase, 
  * neg. int to decrease; return new hub *)
let change_defense amount hub = 
	{ hub with defense = hub.defense + amount }

let get_production hub = hub.production

let get_production_rate hub = hub.production_rate

let get_allowed_roles hub = hub.allowed_roles

let get_defense hub = hub.def

let change_defense amount hub = { hub with def = hub.def + amount }
