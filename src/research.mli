module type Unlockable = struct

	(* culmination of all of the above *)
	type t = {
		name: string;
		resource: string;
		cost: int;
		is_unlocked: bool;
	}

	(* create unlockable from a name, resource, and cost *)
	val create_unlockable : string -> string -> int -> t

	(* returns true if unlockable is unlocked *)
	val is_unlocked : t -> bool

	(* returns amount of a particular resource needed *)
	val resource_needed : t -> int

	(* returns the name of the resource *)
	val resource : t -> string

end

module type Research = struct 

	type t

	type t tree = Leaf | Node of t * t list

	(* adds an unlockable that can be accessed AFTER a certain unlockable  *)
	val add_unlockable: t -> t option -> t tree -> t tree

	(* searches the tree for a certain unlockable name *)
	val get_unlockable: string -> t tree -> t

	(* unlock and return  a potential unlockable if the type and amount of resources is valid
     * otheriwse, returns none *)
	val unlock : t -> resource -> unlockable option

	(* gets every unlockable needed to unlock a certain unlockable *)
	val get_path : t -> t list

	(* returns a list of every unlocked unlockable *)
	val get_unlocked : t tree -> t list

end
