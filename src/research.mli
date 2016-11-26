module type Unlockable = sig

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

module type Research = sig

  type t

  type key

  type value = t list

  type research_list

  val add_unlockable_key: key -> research_list -> research_list

	(* adds an unlockable that can be accessed AFTER a certain unlockable  *)
 val add_unlockable_value: key -> value -> research_list -> research_list

 (* gets the next locked unlockable from the [key]*)
	val get_next_unlockable: key -> research_list -> t option

	(* unlock and return  a potential unlockable based on the next locked unlockable with the key if the type and amount of resources is valid
     * otheriwse, returns none *)
	val unlock : key -> research_list -> unlockable option

	(* returns the list of unlockables based on the key*)
 val get_key_list : key -> research_list ->  value

	(* returns a list of every unlocked unlockable *)
 val get_unlocked : key -> research_list -> list

end
