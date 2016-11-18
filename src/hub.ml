type entity = Entity.t
type role = Entity.role
type resource = Resource.t

type t = {
	name: string;
    descr: string;
	is_finished: bool;
	resource: resource option;
    production_rate: int;
	entities: entity list;
	allowed_roles: role list;
	defense: int;
}

let create ~name ~descr ~starting_entity ~production ~production_amt ~allowed_roles ~def =
	{
		name = name;
        descr = descr;
		is_finished = false;
		resource = production;
        production_rate = production_amt;
  entities = (match starting_entity with
    | Some e -> [e]
    | None -> []);
		allowed_roles = allowed_roles;
		defense = def
	}

let describe hub =
  failwith "Unimplemented"

let is_finished hub = hub.is_finished

let set_finished hub = { hub with is_finished = true }

let get_resource hub = hub.resource

let add_entity new_entity hub = 
  failwith "Unimplemented"
	(* if List.mem new_entity.role hub.allowed_roles then *)
	(* 	if not List.mem entity hub.entities then *)

	(* 	{ hub with entities = hub.entities @ [new_entity] } *)

	(* 	(\* TODO: handle exceptions when bad stuff happens *\) *)

	(* 	else hub  *)
	(* else hub *)

let remove_entity old_entity hub = 
  failwith "Unimplemented"
	(* let new_entity_list =  *)
	(* 	List.filter  *)
	(* 		(fun entity -> not (entity = old_entity)) *)
	(* 	hub.entities in *)

	(* {  *)
	(* 	name = hub.name; *)
	(* 	resource = hub.resource; *)
	(* 	entities = hub.entities @ entity; *)
	(* 	defense = hub.defense *)
	(* } *)

let get_defense hub = hub.defense

let set_defense amount hub = 
  failwith "Unimplemented"
	(* { *)
	(* 	name = hub.name; *)
	(* 	resource = hub.resource; *)
	(* 	entities = hub.entities; *)
	(* 	defense = hub.defense + amount; *)
	(* } *)

let get_allowed_roles hub =
  failwith "Unimplemented"

let get_production_rate hub =
  failwith "Unimplemented"

let get_name hub =
  failwith "Unimplemented"
