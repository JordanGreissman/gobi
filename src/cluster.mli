open Ast
open Resource

module type Hub : Describable = struct 

	type hub

	(* = { 
		cluster_id : string;
		production_type : resource;
		production_amount : int
		unit_population : unit list;
		tile : tile;
	} *)

	(* Returns a new hub based on parameters and adds it to the cluster *)
	val new_hub    : resource -> unit list -> hub

	(* Returns a new hub based on parameters and adds it to the cluster *)
	val remove_hub : hub -> hub list

	(* Change the multiplier for the production output *)
	val change_production : int -> hub

	(* Add units to a hub, affecting production *)
	val add_units : unit_list -> hub

	(* Remove units to a hub, affecting production *)
	val remove_units : unit_list -> hub

end

module type Unit : Describable = struct 

  type power_level 

	(*{
		total : int; (* sum of attack / defense *)
		attack : int;
		defense : int; 
	}*)

	type unit 

	(*{
		hub : hub;
		tile : tile;
		power_level : power_level;
	}*)

	(* Create a unit with a certain power level, starting at a cluster's town hall
	 * hub *)
	val create_unit : cluster -> power_level

	(* Increase / decrease the attack value of a unit, using + / - values. 
	 * This affects total power levels *)
	val change_attack : int -> unit

	(* Increase / decrease the defense value of a unit, using + / - values. 
	 * This affects total power levels *)
	val change_defense : int -> unit

	(* Move a unit to a new tile, affecting both structures *)
	val move_to_tile : tile -> unit

	(* Move a unit to a new hub, affecting borth structures and hub production *)
	val move_to_hub : hub -> unit

end

module type Cluster : Describable = struct 

	type cluster 

	(*{
		name : string
		tiles : tile list;
		town_hall : hub
		units : unit list;
		hubs : hub list;
	}*)

	(* creates a new cluster based on existing units on a settled tile *)
	val create_cluster : tile -> unit list -> cluster

end

