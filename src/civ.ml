
type t = {
   name : string;
   entities : Entity.t list;
   clusters : Cluster.t list;
   techs : research_list;
   player_controlled : boolean;
}
