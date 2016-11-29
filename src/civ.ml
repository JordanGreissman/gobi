
type t = {
   name : string;
   desc : string;
   entities : Entity.t list;
   clusters : Cluster.t list;
   techs : Research.Research.research_list;
   player_controlled : bool;
}

let get_player_controlled civ =
  civ.player_controlled