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
