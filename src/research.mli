module Unlockable : sig

  type treasure =
	  | Hub of Hub.role list * int
    | Production of Hub.role * Hub.production list

  type t = {
	  name: string;
	  resource: Resource.t; (* type needed to unlock *)
	  cost: int; (* how much of above resource *)
	  is_unlocked: bool;
	  treasure: treasure
  }

  (** Creates treasure that affect the production rate of hubs *)  
  val create_treasure_hub : Hub.role list -> int -> treasure

  (** Creates treasure that affect the production of hubs *)
  val create_treasure_prod : Hub.role -> Hub.production list -> treasure

  (** Creates unlockable from a name, resource, and cost, and treasure *)
  val create_unlockable : name:string -> resource:Resource.t -> cost:int ->
    treasure:treasure -> t

  (** Returns true if unlockable is unlocked *)
  val is_unlocked : t -> bool

  (** Returns the treasure of an unlockable *)
  val treasure : t -> treasure

  (** Returns amount of a particular resource needed to unlock an unlockable *)
  val resource_needed : t -> int

  (** Returns the name of the resource of the unlockable *)
  val resource : t -> Resource.t

  (** Returns the name of the unlockable itself *)
  val name : t -> string

  (* Returns a description of a series of locked / unlocked unlockables *)
  val describe_unlocked : t list -> string

end

module Research : sig

  type t = Unlockable.t

  type key = string (** The identifier for each area of research *)

  type value = t list 

  type research_list = (key * value) list

  (* Faciliate going from JSON to research tree. Respectively takes
   * the tech name, the resource type string (lower / uppercase of resource)
   * the amount (int) of the treasure / upgrade
   * the affected hub's name (string),
   * the amount (int)
   * the string list of roles made, if any
   * the list of all Entity.role(s) made
   * the list of all Hub.role(s) made
 	 *)
  val extract_to_value : string -> string -> int -> string -> int ->
 	  string list -> Entity.role list -> Hub.role list -> t

  (** Returns list of all possible keys *)
  val get_keys : string list

  (** Creates a tree from a list of keys and values, which must be the same size *)
  val create_tree : key list -> value list -> research_list -> research_list

  (** Adds a value under a certain key to a valid research_list, returning the list *)
  val add_unlockable_key: key -> value -> research_list -> research_list

  (** Gets the next locked unlockable from the [key], None if there isn't one *)
  val get_next_unlockable: key -> research_list -> t option

  (** Unlock and return a potential unlockable based on the next locked unlockable 
	  * with the key, otherwise returns None *)
  val unlock : key -> research_list -> research_list

  (** Replaces unlockable based on name of resource, returns new research list *)
  val replace_unlockable : t -> research_list -> research_list

  (** Returns the list of unlockables based on the key *)
  val get_key_list : key -> research_list ->  value

  (** Returns a list of every unlocked unlockable *)
  val get_unlocked : key -> research_list -> t list

  (** Returns true if for some (k, v) in [research_list], every Unlockable in 
    * v has been unlocked, otherwise false *)
  val check_complete : research_list -> bool

  (** Returns fraction (float between 0 and 1, inclusive) of a branch unlocked *)
  val frac_unlocked : (key * value) -> float

end
