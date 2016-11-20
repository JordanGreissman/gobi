open Resource
open Entity

type t = {
	name: string;
	is_finished: bool;
	resource: resource option;
	entities: entity list option;
	allowed_roles: role list;
	defense: int;
}

(** Returns a new hub with a name and production_type string on a 
  * certain tile and cluster and adds it to the cluster. Default
  * production amount is 0, with no entities *)
let create name built_by resource allowed_roles defense =

	let entity_list = begin match built_by with 
		| None -> None
		| Some entity -> Some [entity]
	end in

	{
		name = name;
		is_finished = false;
		resource = resource;
		entities = entity_list;
		allowed_roles = allowed_roles
		defense = defense
	}

(* Returns bool of whether the hub is complete or under construction *)
let is_finished hub = hub.is_finished

(* Set hub as finished, returning the new hub *)
let set_finished hub = { hub with is_finished = true }

(** Returns resource of hub *)
let get_resource hub = hub.resource

(** Returns the hub with a new resource passed in *)
let set_resource new_resource hub = { hub with resource = new_resource }

(** Add entity to a hub, returning the new hub *)
let add_entity new_entity hub = 

	if List.mem new_entity.role hub.allowed_roles then
		if not List.mem entity hub.entities then

		{ hub with entities = hub.entities @ [new_entity] }

		(* TODO: handle exceptions when bad stuff happens *)

		else hub 
	else hub

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

