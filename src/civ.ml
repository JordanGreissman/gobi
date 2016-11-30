
type t = {
   name : string;
   desc : string;
   entities : Entity.t list;
   pending_entities : Entity.t list;
   clusters : Cluster.t list;
   pending_hubs : Hub.t list;
   techs : Research.Research.research_list;
   player_controlled : bool;

}

let remove_entity entity civ =
  let new_e_list = List.filter (fun e -> not (e = entity)) civ.entities in
    { civ with entities = new_e_list }

(** Add entity to a hub, returning the new hub and civ in a tuple.
  * Raise Illegal if entity role isn't allowed in the hub *)
let add_entity_to_hub entity hub civ =
  if List.mem (Entity.get_role entity) (Hub.get_allowed_roles hub)
  then
    let new_civ = remove_entity entity civ in
    let new_hub = { hub with production_rate = Hub.get_production_rate hub + 1 } in
      (new_hub, new_civ)
  else raise (Exception.Illegal "This entity has the wrong role for the hub"); (hub, civ)

let get_player_controlled civ =
  civ.player_controlled