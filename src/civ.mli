(** represents the state of a civ in the game *)

type t = {
  (** name of the civilization *)
  name : string;
  (** description of the civ *)
  desc : string;
  (** list of entities currently on the map *)
  entities : Entity.t list;

  pending_entities : Entity.t list;
  (** list of clusters currently on the map *)
  clusters : Cluster.t list;

  pending_hubs : Hub.t list;
  (** Entities that can be made and used *)

  unlocked_entities : Entity.role list;
  (** count of resources accrued *)
  resources : (Resource.t * int) list;
  (** list of all techs, some of which may be locked *)
  techs : Research.Research.research_list;
  (** whether the civ is player or ai controlled *)
  player_controlled : bool;
  (** the next id to assign to entities *)
  next_id : int;
}

(** Applies a function for clusters on every cluster in a civ. Acc should be [].
  * Returns civ with new cluster list *)
val cluster_map : (Cluster.t -> Cluster.t) -> t -> Cluster.t list -> t

(* An arbitrary score for the civ based on it's contents *)
val score: t -> int

(** apply map function to each hub in civ, returning some 'a list *)
val hub_map_poly : (Hub.t -> 'a) -> 'a -> t -> 'a list

(* Returns civ with added resrouces for the turn *)
val get_resource_for_turn : t -> t

(* Returns new civ with entity role added that's been unlocked *)
val add_unlocked_entity : Entity.role -> t -> t

(* Change hubs based on research and return a new hub *)
val apply_research : Research.Unlockable.t -> t -> t

(** Returns civ with an entity list without the passed in entity *)
val remove_entity : Entity.t -> t -> t

(** Replace entity with id of new_entity with new_entity *)
val replace_entity : Entity.t -> t -> t

(* Check civ's resources and unlocks if possible. Returns
 * same civ if can't, otherwise changed civ with unlocked tech *)
val unlock_if_possible : string -> Research.Research.research_list -> t -> t

val add_entity : Entity.role -> Tile.t -> t -> t

(** Add entity to a hub in existing civ, returning the new civ.
  * Raise Illegal if entity role isn't allowed in the hub. Does nothing if hub
  * doesn't exist in clusters. *)
val add_entity_to_hub : Entity.t -> Hub.t -> t -> t

(** Returns true if the civ isn't run by AI *)
val get_player_controlled : t -> bool

(* Returns tech tree, some of which may be locked *)
val get_tree : t ->  Research.Research.research_list

(* Gets resources of civ *)
val get_resources : t -> (Resource.t * int) list

