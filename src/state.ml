type t = {
  civs : Civ.t list;
  turn : int;
  total_turns : int;
  hub_roles : Hub.role list;
  entity_roles : Entity.role list;
  tech_tree : Research.Research.research_list;
  map : Mapp.t;
  screen_top_left : Coord.Screen.t;
  selected_tile : Coord.t;
  messages : Message.t list;
  menu : Menu.t list;
  pending_cmd : Cmd.t option;
  is_quit : bool;
  current_civ : int;
}

let get_current_civ s =
  List.nth s.civs s.current_civ

let update_civ i civ s =
  let arr = Array.of_list s.civs in
  arr.(i) <- civ;
  let civs = Array.to_list arr in
  {s with civs = civs}

let get_civs s =
  s.civs

let get_tree s = s.tech_tree
