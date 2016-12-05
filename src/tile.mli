(** the type of a tile *)
type t

(** a tile can have one of these terrain types *)
type terrain = Flatland | Mountain | Forest | Desert

(** Create and return a tile.
  * [terrain] is the terrain type for the tile. *)
val create : terrain:terrain -> pos:Coord.t -> t

(** Returns a description of the tile *)
val describe : t -> string

val describe_terrain : terrain -> string

(** Create a hub and place it on this tile, also returning a potentially
  * different civ. For descriptions of the named parameters, see hub.mli.
  * IMPORTANT: if entity not None you must call Civ.remove_entity starting_entity
  * civ after.
  * [starting_entity] is an entity that will automatically be consumed by the
  *   new hub when it is finished being built, if such an entity exists.
  *   Typically this is the first entity to start construction of the hub.
  *)
val place_hub :
  role : Hub.role ->
  starting_entity : Entity.t option ->
  tile : t ->
  t

(** [move_entity from to] is a 2-tuple [(from',to')] where [from'] is the updated
  * version of [from] and [to'] is the updated version of [to]. The tiles are
  * updated by moving the entity on [to] to [from].
  * Raises Illegal if there is no entity on [from].
  *)
val move_entity : t -> t -> t * t

(** Returns the distance (float) between two tiles *)
val distance_between_tiles: t -> t -> float

(** [get_art_char c t] is the art cell for the absolute screen coordinate [c],
  * which is contained within tile [t]. This is the art cell for the entity on
  * [t]; or if there is no entity, the hub on [t]; or if there is also no hub,
  * the terrain of [t].
  *)
val get_art_char : Coord.Screen.t -> t -> Art.cell option

(** Returns the terrain type of the tile *)
val get_terrain : t -> terrain

(** Changes the terrain type of the tile, returning the new tile *)
val set_terrain : t -> terrain -> t

(** Returns true if the tile has been settled *)
val is_settled : t -> bool

(** Returns a tile that is unsettled *)
val unsettle : t -> t

(** Returns true if the entity on a tile is a worker *)
val is_entity_worker: t -> bool

(** Changes a forest to a flatland tile, otherwise raises Illegal *)
val clear : t -> t

(** Returns Some hub on a tile, otherwise None *)
val get_hub : t -> Hub.t option

(** Changes a potential hub on a tile, returning the tile with the possible hub *)
val set_hub : t -> Hub.t option -> t

(** Returns Some entity on a tile if any, otherwise None *
  * Note: only one entity is allowed per tile *)
val get_entity : t -> Entity.t option

(** Changes a potential entity on a tile, returning the tile with an 
  * entity (if any) *)
val set_entity : t -> Entity.t option -> t

(** Returns an entity that is guaranteed to be there, otherwise Illegal *)
val get_known_entity: t -> Entity.t

(** Returns the coordinates of the tile *)
val get_pos : t -> Coord.t

(** Returns true if entities / hubs are allowed on this tile *)
val has_movement_obstruction : t -> bool

(** Returns the number of turns it takes an entity to traverse this tile
  *  for tiles where [movementObstruction = true], [costToMove = -1] *)
val cost_to_move : t -> int

(** Returns true if tile needs to be cleared before it can be settled *)
val needs_clearing : t -> bool

(** Returns true if hubs can be built on tile *)
val has_building_restriction : t -> bool

(** Returns true if farms can be built on this tile *)
val has_food_restriction : t -> bool
