type t = {
  civs : Civ.t list;
  turns_left : int;
  hub_roles : Hub.role list;
  entity_roles : Entity.role list;
  tech_tree : Research.Research.research_list;
  map : Mapp.t;
  screen_top_left : Coord.Screen.t;
  selected_tile : Coord.t;
  messages : string list;
  menu : Menu.t list;
  pending_cmd : Cmd.t option;
  is_quit : bool;
  current_civ : int;
}

let get_current_civ s =
  List.nth s.civs s.current_civ