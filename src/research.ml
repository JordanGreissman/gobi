module type Unlockable =
sig
  type t
  val create_unlockable : string -> string -> int -> t
  val is_unlocked : t -> bool
  val resource_needed : t -> int
  val resource : t -> string
end

module Unlockables (U: Unlockable) =
struct

  type t = {
    name: string;
    resource: string;
    cost: int;
    is_unlocked: bool;
  }

  let create_unlockable ~name ~resource ~cost =
    {name;resource;cost;is_unlocked=false}

  let is_unlocked t =
    t.is_unlocked

  let resource_needed t =
    t.cost

  let resource t =
    t.resource
end

module type Research =
sig
  type t
  type key
  type value
type research_list
  val add_unlockable_key: key -> research_list -> research_list
  val add_unlockable_value: key -> value -> research_list -> research_list
  val get_next_unlockable: key -> research_list -> t option
  val unlock : key -> research_list -> unlockable option
  val get_key_list : key -> research_list -> value
  val get_unlocked : key -> research_list -> list
end

module Researches (R: Research) =
struct
  type t = Unlockables.t

  type key = idk

  type  value = t list

  type research_list = (key * value) list

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
