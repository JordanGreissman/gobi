
module Unlockable =
struct

  type treasure =
    | Hub of Hub.hub * int
    | Production of (Hub.hub * Hub.production) list

  type t = {
    name: string;
    resource: string;
    cost: int;
    is_unlocked: bool;
    treasure: treasure;
  }

  let create_treasure_hub hub amt =
    Hub (hub, amt)

  let create_treasure_prod hub_prod_list =
    Production hub_prod_list

  let create_unlockable ~name ~resource ~cost ~treasure =
    {name;resource;cost;is_unlocked=false;treasure}

  let is_unlocked t =
    t.is_unlocked

  let resource_needed t =
    t.cost

  let resource t =
    t.resource
end

module Research =
struct
  type t = Unlockable.t

  type key = string

  type value = t list

  type research_list = (key * value) list 

  let extract_to_value name res_str cost u_hub u_amt u_entity = 
    let treasure = ( if u_entity = [] 
      then Unlockable.create_treasure_hub u_hub u_amt
      else Unlockable.create_treasure_prod [(hub, u_entity)]
    ) in create_unlockable name (str_to_res res_str) cost treasure

  let rec create_tree key_list value_list acc_tree =
    match key_list, value_list with
      | [], [] -> acc_tree
      | key::key_tail, value::value_tail ->
        let tree = add_unlockable_value key value
          (add_unlockable_key key acc_tree) in
        create_tree key_tail value_tail tree
      | _ -> failwith "Precondition violation"

  let add_unlockable_key key research_list =
    (key * []) @ research_list

  let add_unlockable_value key value research_list =
    let value_list = List.assoc key research_list in
    let new_value_list = value_list @ [value] in
    let value_list_before_update = List.remove_assoc key research_list in
    (key * new_value_list) @ value_list_before_update

  let get_next_unlockable key research_list =
    let value_list = List.assoc key research_list in
    try
      let next_unlockable = List.find (fun x -> not (x.is_unlocked)) value_list in
      Some next_unlockable
    with
    | Not_found -> None

  let unlock key research_list =
    None (*need to get more info on this*)

  let get_key_list key research_list =
    List.assoc key research_list

  let get_unlocked key research_list =
    let value_list = List.assoc key research_list in
    List.filter (fun x -> x.is_unlocked) value_list
end
