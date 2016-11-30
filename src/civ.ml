
type t = {
   name : string;
   desc : string;
   entities : Entity.t list;
   pending_entities : Entity.t list;
   clusters : Cluster.t list;
   pending_hubs : Hub.t list;
   techs : Research.Research.research_list;
   player_controlled : bool;
   next_id : int;
}

(** Returns civ with an entity list without the passed in entity *)
let remove_entity entity civ =
  let new_e_list = List.filter (fun e -> not (e = entity)) civ.entities in
    { civ with entities = new_e_list }

(** Add entity to a hub in existing civ, returning the new civ.
  * Raise Illegal if entity role isn't allowed in the hub. Does nothing if hub
  * doesn't exist in clusters. *)
let add_entity_to_hub entity hub civ =
  if List.mem (Entity.get_role entity) (Hub.get_allowed_roles hub) then
    let parsed_clusters = List.map
      (fun c -> Cluster.add_entity_to_hub entity hub c) civ.clusters in
    let new_civ = { civ with clusters = parsed_clusters } in
      remove_entity entity new_civ
  else raise (Exception.Illegal "This entity has the wrong role for the hub"); civ

(** Returns true if the civ isn't run by AI *)
let get_player_controlled civ =
  civ.player_controlled