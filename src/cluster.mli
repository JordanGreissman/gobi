open Resource

module type Cluster = struct 

	type t = {
		name: string;
		town_hall: hub;
		tiles: tile list;
		hubs: hub list;
	}

	(* creates a new cluster based on existing units on a settled tile *)
	val create_cluster : tile -> t

end

