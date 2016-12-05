(** represents the state of a civ in the game *)

type t = {
  (** name of the civilization *)
  name : string;
  (** description of the civ *)
  desc : string;
  (** list of entities currently on the map *)
  entities : Entity.t list;
  (** list of entities that are in the process of being built *)
  pending_entities : Entity.t list;
  (** list of clusters currently on the map *)
  clusters : Cluster.t list;
  (** list of hubs that are in the process of being built *)
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

(** An arbitrary score for the civ based on its contents *)
val score: t -> int

(** Apply function to each hub in a civ, with some fallback value if 
  * if there is no hub. Returns 'a list *)
val hub_map_poly : (Hub.t -> 'a) -> 'a -> t -> 'a list

(** Returns civ with added resources for the turn from hubs *)
val get_resource_for_turn : t -> t


(* delete? *)
(** Returns true if the hub can be bought with resources *)
val check_hub_cost : Hub.t -> t -> bool


(** Returns new civ with an entity role added to list *)
val add_unlocked_entity : Entity.role -> t -> t

(** Change all hubs based on the unlockable passed in and return new civ *)
val apply_research : Research.Unlockable.t -> t -> t

(** Returns civ with entity list without the passed in entity *)
val remove_entity : Entity.t -> t -> t

(** Replace entity with id of new_entity with new_entity *)
val replace_entity : Entity.t -> t -> t

(** Check civ's resources and unlocks if possible. Returns
  * same civ if can't, otherwise changed civ with unlocked tech *)
val unlock_if_possible : string -> Research.Research.research_list -> t -> t

(** Adds entities to pending entities in civ *)
val add_entity : Entity.role -> Tile.t -> t -> t

(** Add entity to a hub in existing valid civ, returning the new civ.
  * Raise Illegal if entity role isn't allowed in the hub. Returns same
  * civ if hub doesn't exist in clusters. *)
val add_entity_to_hub : Entity.t -> Hub.t -> t -> t

(** Returns true if valid civ isn't run by AI *)
val get_player_controlled : t -> bool

(** Returns tech tree of valid civ, some of which may be locked *)
val get_tree : t ->  Research.Research.research_list

(** Returns resources of valid civ *)
val get_resources : t -> (Resource.t * int) list

