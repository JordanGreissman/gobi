(** the type of a tile *)
type t

(** a tile can have one of these terrain types *)
type terrain = Flatland | Mountain | Forest | Desert

(** Create and return a tile.
  * [terrain] is the terrain type for the tile.
  *)
val create : terrain:terrain -> t

val describe : t -> string
val describe_terrain : terrain -> string

(** Create a hub and place it on this tile. For descriptions of the named
  * parameters, see hub.mli *)
val place_hub :
  name : string ->
  descr : string ->
  starting_entity : Entity.t option ->
  (* TODO: Can a hub produce multiple types of resources/entities? If so, then
   * this should be a [production list] instead, and [production_rate] should be
   * a [float list] *)
  production : Hub.production ->
  production_rate : float ->
  allowed_roles : Entity.role list ->
  def : int ->
  tile : t ->
  t

(** Move the entity from [to_tile] (the tile at the position specified by the
  * first arg) to [from_tile] (the tile at the position specified by the second
  * arg). Return a 2-tuple [(updated_to_tile,updated_from_tile)].
  *)
val move_entity : Coord.t -> Coord.t -> t*t

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
