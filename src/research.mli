module type Unlockable = sig

	type treasure = 
	  | Hub (hub * int) list
    | Production of (hub * production) list

	(* culmination of all of the above *)
	type t = {
		name: string;
		resource: string;
		cost: int;
		is_unlocked: bool;
		treasure: treasure
	}

	(* creates various treasures *)
	val create_treasure_hub : hub * int -> treasure
	val create_treasure_prod : (hub * production) list -> treasure

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

  (* Faciliate going from JSON to research tree. Respectively takes 
   * the tech name, the resource type string (lower / uppercase of resource)
   * the amount (int) of the treasure / upgrade, and then then the upgrade 
   * details: the affected hub's name (string), the amount (int) and 
   * list of new production (can be empty ot a string list) *)
  val extract_to_value : string -> string -> int -> string -> int -> 
  	string list -> value

  (* Creates a tree from a list of keys and list of list of values, which 
   * must be the same size. Pass an empty list for the third parameter. *)
  val create_tree : key list -> value list -> research_list -> research_list

  val add_unlockable_key: key -> research_list -> research_list

	(* adds an unlockable that can be accessed AFTER a certain unlockable  *)
 val add_unlockable_value: key -> value -> research_list -> research_list

 (* gets the next locked unlockable from the [key]*)
	val get_next_unlockable: key -> research_list -> t option

	(* unlock and return a potential unlockable based on the next locked unlockable with the key if the type and amount of resources is valid
     * otheriwse, returns none *)
	val unlock : key -> research_list -> unlockable option

	(* returns the list of unlockables based on the key*)
 val get_key_list : key -> research_list ->  value

	(* returns a list of every unlocked unlockable *)
 val get_unlocked : key -> research_list -> list

end
