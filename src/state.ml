open Core_kernel

type t = {
  civs : Civ.t Array.t;
  current_civ : Civ.t;
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
  (* pending_cmd : Cmd.t option; *)
  is_quit : bool;
  is_tutorial : bool;
}

let update_current_civ new_civ s =
  let (i,_) = Array.findi_exn ~f:(fun i c -> (phys_equal c s.current_civ)) s.civs in
  Array.set s.civs i new_civ;
  s
