
module Unlockable =
struct

  type treasure =
    | Hub of Hub.role list * int
    | Production of Hub.role * Hub.production list

  type t = {
    name: string;
    resource: Resource.t;
    cost: int;
    is_unlocked: bool;
    treasure: treasure;
  }

  let create_treasure_hub hub_list amt =
    Hub (hub_list, amt)

  let create_treasure_prod hub prod_list =
    Production (hub, prod_list)

  let create_unlockable ~name ~resource ~cost ~treasure =
    {name;resource;cost;is_unlocked=false;treasure}

  let is_unlocked t =
    t.is_unlocked

  let resource_needed t =
    t.cost

  let resource t =
    t.name
end

module Research =
struct
  type t = Unlockable.t

  type key = string

  type value = t list

  type research_list = (key * value) list

  let extract_to_value name res_str cost u_hub u_amt u_entity
  entity_role_list hub_role_list =
    let hub_list = Hub.find_role u_hub hub_role_list in
    let treasure = ( if u_entity = []
      then Unlockable.create_treasure_hub hub_list u_amt
      else
        let prod_list = List.map
          (fun entity -> Hub.Entity
            (Entity.find_role entity entity_role_list)) u_entity
        in Unlockable.create_treasure_prod (List.hd hub_list) prod_list
      ) in
    let resource = match Resource.str_to_res res_str with
      | Some r -> r
      | None   -> failwith "no resource provided" in
    Unlockable.create_unlockable name resource cost treasure

  let add_unlockable_key key value research_list =
    (key,value)::research_list

  let rec create_tree key_list value_list acc_tree =
    match key_list, value_list with
      | [], [] -> acc_tree
      | key::key_tail, value::value_tail ->
        let key_value_tree = add_unlockable_key key value acc_tree in
        create_tree key_tail value_tail key_value_tree
      | _ -> failwith "Precondition violation"

  let get_next_unlockable key research_list =
    let value_list = List.assoc key research_list in
    try
      let next_unlockable = List.find (fun x -> not (Unlockable.is_unlocked x)) value_list in
      Some next_unlockable
    with
    | Not_found -> None

  let unlock key research_list =
    None (*need to get more info on this*)

  let get_key_list key research_list =
    List.assoc key research_list

  let get_unlocked key research_list =
    let value_list = List.assoc key research_list in
    List.filter (fun x -> Unlockable.is_unlocked x) value_list
end
