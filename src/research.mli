module type Unlockable : Describable = struct

	(* string - name of research element *)
	type name

	(* string - resource needed to unlock *)
	type resource

	(* int - amount of resource needed to unlock *)
	type unlockable_amount

	(* bool - if is unlocked *)
	type unlocked

	(* culmination of all of the above *)
	type unlockable

	(* create unlockable *)
	val create_unlockable : name -> resource -> unlockable_amount -> unlockable

	(* returns true if unlockable is unlocked *)
	val is_unlocked : unlockable -> bool

end

module type Research : Describable = struct 

	type unlockable tree = Leaf | Node of unlockable * unlockable tree list


	(* = { 
		cluster_id : string;
		production_type : resource;
		production_amount : int
		unit_population : unit list;
		tile : tile;
	} *)

	(* adds an unlockable that can be accessed AFTER a certain unlockable  *)
	val add_unlockable: unlockable -> unlockable option -> 
		unlockable tree -> unlockable tree

	(* searches the tree for a certain unlockable *)
	val get_unlockable: name -> unlockable tree -> unlockable

	(* unlock and return  a potential unlockable if the type and amount of resources is valid
     * otheriwse, returns none *)
	val unlock : unlockable -> resource -> unlockable option

	(* gets every unlockable needed to unlock a certain unlockable *)
	val get_path : unlockable -> unlockable list

	(* returns a list of every unlocked unlockable *)
	val get_unlocked : unlockable tree -> unlockable list

end
