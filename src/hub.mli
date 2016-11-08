open Entity
open Cluster

module type Hub = struct 

	type t = {
		name: string;
		production_type: string;
		production_amount: int;
		entities: entity list;
		cluster: cluster;
		tile: tile;
	}

	(* Returns a new hub with a name and production_type string on a 
	 * certain tile and cluster and adds it to the cluster *)
	val new_hub : string -> string -> cluster -> tile -> t

	(* Returns a new hub based on parameters and removes it from the cluster *)
	val remove_hub : t -> t list

	(* Change the multiplier for the production output *)
	val change_production_amount : int -> t

	(* Add entities to a hub, affecting production *)
	val add_entities : entity list -> t

	(* Remove entities to a hub, affecting production *)
	val remove_entities : entity list -> t

end

