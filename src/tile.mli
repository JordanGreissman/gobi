(** the type of a tile *)
type t

(** a tile can have one of these terrain types *)
type terrain = Flatland | Mountain | Forest | Desert

(* getters and setters *)

val get_terrain : t -> terrain
val set_terrain : t -> terrain -> t

val is_settled : t -> bool
val settle : t -> t
val unsettle : t -> t

val get_hub : t -> Hub.t option
val set_hub : t -> Hub.t option -> t

val get_entity : t -> Entity.t option (* only one entity is allowed per tile *)
val set_entity : t -> Entity.t option -> t

(* terrain property queries *)

(** whether units are allowed on this tile *)
val hasMovementObstruction : t -> bool
(** the number of turns it takes unit to traverse this tile
  *  for tiles where [movementObstruction = true], [costToMove = -1] *)
val costToMove : t -> int
(** whether this tile needs to be cleared before it can be settled *)
val needsClearing : t -> bool
(** whether hubs are allowed on this tile *)
val hasBuildingRestriction : t -> bool
(** whether food hubs are allowed on this tile (e.g. farms) *)
val hasFoodRestriction : t -> bool

(** [create] returns a newly created tile with the given parameters *)
val create : terrain -> bool -> Hub.t option -> Entity.t list -> t
