open Resource
open Entity

type t = {
	name: string;
	resource: resource option;
	entities: entity list;
	defense: int;
}

let create name resource defense =

	let entity_role = Entity.create_role "unassigned role" 0 "town hall" in
	let entity = Entity.create_entity entity_role 1 1 MARK: TILE in

	{
		name = name;
		resource = resource;
		entities = [entity];
		defense = defense
	}

let get_resource hub = hub.resource

let set_resource new_resource hub = 
	{ 
		name = hub.name;
		resource = new_resource;
		entities = hub.entities;
		defense = hub.defense;
	}

let add_entity new_entity hub = 

	MARK:  check the entity can work there

	{ 
		name = hub.name;
		resource = hub.resource;
		entities = hub.entities @ new_entity;
		defense = hub.defense;
	}

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

