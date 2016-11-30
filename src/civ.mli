(** represents the state of a civ in the game *)

type t = {
  (** name of the civilization *)
  name : string;
  (** description of the civ *)
  desc : string;
  (** list of entities currently on the map *)
  entities : Entity.t list;
  (** list of clusters currently on the map *)
  clusters : Cluster.t list;
  (** list of techs that have been unlocked *)
  techs : Research.Research.research_list;
  (** whether the civ is player or ai controlled *)
  player_controlled : bool;
}

(** Returns civ with an entity list without the passed in entity *)
val remove_entity : Entity.t -> t -> t

(** Add entity to a hub in existing civ, returning the new civ.
  * Raise Illegal if entity role isn't allowed in the hub. Does nothing if hub 
  * doesn't exist in clusters. *)
val add_entity_to_hub : Entity.t -> Hub.t -> t -> t

(** Returns true if the civ isn't run by AI *)
val get_player_controlled : t -> bool