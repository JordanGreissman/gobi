open Resource
open Entity

type t = {
	name: string;
	is_finished: bool;
	resource: resource option;
	entities: entity list;
	allowed_roles: role list;
	defense: int;
}

let create name built_by resource allowed_roles defense =

	{
		name = name;
		is_finished = false;
		resource = resource;
		entities = [built_by];
		allowed_roles = allowed_roles
		defense = defense
	}

let is_finished hub = hub.is_finished

let set_finished hub = { hub with is_finished = true }

let get_resource hub = hub.resource

let set_resource new_resource hub = 
	{ 
		name = hub.name;
		resource = new_resource;
		entities = hub.entities;
		defense = hub.defense;
	}

let add_entity new_entity hub = 

	if List.mem new_entity.role hub.allowed_roles then
		if not List.mem entity hub.entities then

		{ hub with entities = hub.entities @ [new_entity] }

		(* TODO: handle exceptions when bad stuff happens *)

		else hub 
	else hub

let remove_entity old_entity hub = 
	let new_entity_list = 
		List.filter 
			(fun entity -> not (entity = old_entity))
		hub.entities in

	{ 
		name = hub.name;
		resource = hub.resource;
		entities = hub.entities @ entity;
		defense = hub.defense
	}

let get_defense hub = hub.defense

let set_defense amount hub = 
	{
		name = hub.name;
		resource = hub.resource;
		entities = hub.entities;
		defense = hub.defense + amount;
	}

