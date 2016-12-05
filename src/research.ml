open Exception

module Unlockable = struct
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
    t.resource

  let name t =
    t.name

  let treasure t = t.treasure

  let describe_unlocked t =
    let unlocked = List.filter (fun x -> x.is_unlocked) t in
    print_endline "here";
    (* let desc = List.map resource unlocked in *)
    let desc = List.fold_right (fun x y -> (name x)^", "^y) unlocked "" in
    if desc = "" then "You have not yet unlocked anything in this tree!"
    else "You have unlocked: "^(String.sub desc 0 ((String.length desc) - 2))
end

module Research = struct
  type t = Unlockable.t
  type key = string
  type value = t list
  type research_list = (key * value) list

  let get_keys = ["Agriculture"; "Transportation"; "Combat"; "Productivity"]

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
      | None   ->
        raise (Critical ("research","extract_to_value","no resource provided")) in
    Unlockable.create_unlockable name resource cost treasure

  let add_unlockable_key key value research_list =
    (key,value)::research_list

  let rec create_tree key_list value_list acc_tree =
    match key_list, value_list with
      | [], [] -> acc_tree
      | key::key_tail, value::value_tail ->
        let key_value_tree = add_unlockable_key key value acc_tree in
        create_tree key_tail value_tail key_value_tree
      | _ -> raise (BadInvariant ("resource","create_tree","input lists are not the same length"))

  let get_next_unlockable key research_list =
    let value_list = List.assoc key research_list in
    try
      let next_unlockable = List.find (fun x -> not (Unlockable.is_unlocked x)) value_list in
      Some next_unlockable
    with
    | Not_found -> None

  let unlock key research_list =
    match get_next_unlockable key research_list with
    | None -> research_list (* raise (Exception.Illegal
      ("You have already unlocked everything in "^key^"!")) *)
    | Some u -> let unlocked = { u with is_unlocked = true } in
                let branch = List.assoc key research_list in
                let foo = List.map (fun x ->
                  Unlockable.resource x = Unlockable.resource unlocked)
                  branch in
                let rec index_of_true i = function
                  | [] -> -1
                  | h::t -> if h then i else index_of_true (i+1) t in
                let index = index_of_true 0 foo in
                let index =
                  match index with
                  | -1 -> raise (Critical ("Research.ml",
                                  "unlock",
                                  "Could not find name of unlockable"))
                  | _ -> index in
                let lazy_swap = Array.of_list branch in
                lazy_swap.(index)<-unlocked;
                let branch = Array.to_list lazy_swap in
                let lst = List.map (fun (k, v) ->
                  if (k = key) then (k, branch)
                  else (k, v)) research_list in
                lst

  let rec replace_unlockable new_u research = 
    let rec replace_in_list new_u = function
      | [] -> []
      | u::t -> if (Unlockable.resource u) = (Unlockable.resource new_u)
        then new_u::(replace_in_list u t)
        else u::(replace_in_list u t)
      in
    match research with
      | [] -> []
      | (key, branch)::t -> 
        let new_value = (key, replace_in_list new_u branch) in
          new_value::(replace_unlockable new_u t)


  let get_key_list key research_list =
    List.assoc key research_list

  let get_unlocked key research_list =
    let value_list = List.assoc key research_list in
    List.filter (fun x -> Unlockable.is_unlocked x) value_list

  let check_complete research_list =
    let check key = ((get_next_unlockable key research_list) = None) in
    List.fold_right (fun (k, v) a -> check k || a) research_list false

  let rec frac_unlocked branch = 
    let total = float_of_int (List.length (snd branch)) in
    match snd branch with
      | [] -> 0.0
      | u::t -> if Unlockable.is_unlocked u 
                then (1.0 /. total) +. (frac_unlocked ("", t))
                else (frac_unlocked ("", t))

end
