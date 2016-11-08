open Resource

module type Hub : Describable = struct 

	(* string - id *)
	type cluster

	(* string *)
	type production_type

	(* int *)
	type production_amount

	(* bit list *)
	type bits

	type tile

	(* Returns a new hub based on parameters and adds it to the cluster *)
	val new_hub    : resource -> bit list -> hub

	(* Returns a new hub based on parameters and adds it to the cluster *)
	val remove_hub : hub -> hub list

	(* Change the multiplier for the production output *)
	val change_production : int -> hub

	(* Add units to a hub, affecting production *)
	val add_units : bit list -> hub

	(* Remove units to a hub, affecting production *)
	val remove_units : bit list -> hub

end

module type Bit : Describable = struct 

	(* ( attack: int, defense: int) *)
  type power_level 

	type tile

	type hub

	(* Create a unit with a certain power level, starting at a cluster's town hall
	 * hub *)
	val create_unit : cluster -> power_level

	(* Increase / decrease the attack value of a unit, using + / - values. 
	 * This affects total power levels *)
	val change_attack : int -> unit

	(* Increase / decrease the defense value of a unit, using + / - values. 
	 * This affects total power levels *)
	val change_defense : int -> bit

	(* Move a unit to a new tile, affecting both structures *)
	val move_to_tile : tile -> bit

	(* Move a unit to a new hub, affecting borth structures and hub production *)
	val move_to_hub : hub -> bit

end

module type Cluster : Describable = struct 

	(* string *)
	type name

	(* tile list *)
	type tiles

	(* hub *)
	type town_hall

	(* bit list *)
	type bits

	(* hub list *)
	type hubs 

	(* creates a new cluster based on existing units on a settled tile *)
	val create_cluster : tile -> bit list -> cluster

end

