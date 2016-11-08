open Resource

module type Cluster : Describable = struct 

	type t = {
		name: string;
		town_hall: tile;
		tiles: tile list;
		hubs: hub list;
	}

	(* creates a new cluster based on existing units on a settled tile *)
	val create_cluster : tile -> bit list -> cluster

end

