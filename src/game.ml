open Yojson
open Lwt
open CamomileLibrary

type state = State.t

let make_move st cmd =
  failwith "Unimplemented"

let parse_input s =
  failwith "Unimplemented"

let turn st =
  failwith "Unimplemented"

(* Error handling necessary? *)
let load_json s =
  try Yojson.Basic.from_file s with
  | _ -> print_endline "Illegal: File does not exist or is not a JSON\n";
          failwith "whoops"

let get_assoc s json =
  json |> Yojson.Basic.Util.member s
    |> Basic.Util.to_list |> Basic.Util.filter_assoc

let extract_list str lst =
  let json_list = List.assoc str lst |> Basic.Util.to_list in
  Basic.Util.filter_map (Basic.Util.to_string_option) json_list

let extract_game assoc =
  let turns = (List.assoc "turns" assoc) |> Basic.Util.to_int in
  let ai = (List.assoc "ai" assoc) |> Basic.Util.to_int in
  (turns, ai)

let extract_techs tup =
  let assoc = fst tup in
  let tech = (List.assoc "tech" assoc) |> Basic.Util.to_string in
  let resource = (List.assoc "resource" assoc) |> Basic.Util.to_string in
  let cost = (List.assoc "cost" assoc) |> Basic.Util.to_int in
  let treasure = (List.assoc "treasure" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let treasure = List.nth treasure 0 in
  let hub = (List.assoc "hub" treasure) |> Basic.Util.to_string in
  let amount = (List.assoc "amount" treasure) |> Basic.Util.to_int in
  let entity = extract_list "entity" treasure in
  Research.Research.extract_to_value tech resource cost hub amount entity (snd tup)

let extract_unlockable tup =
  let assoc = fst tup in
  let foo = snd tup in
  let branch = (List.assoc "branch" assoc) |> Basic.Util.to_string in
  let techs = (List.assoc "techs" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let techs = List.map (fun tech -> (tech, foo)) techs in
  let techs = List.map extract_techs techs in
  (branch, techs)

let extract_hub assoc =
  let name = (List.assoc "name" assoc) |> Basic.Util.to_string in
  let desc = (List.assoc "desc" assoc) |> Basic.Util.to_string in
  let builder = (List.assoc "built by" assoc) |> Basic.Util.to_string in
  let defense = (List.assoc "defense" assoc) |> Basic.Util.to_int in
  let cost = (List.assoc "cost" assoc) |> Basic.Util.to_int in
  let entities = extract_list "entities" assoc in
  let generates = (List.assoc "generates" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let generates = List.nth generates 0 in
    let resource = (List.assoc "resource" generates) |> Basic.Util.to_string in
    let amount = (List.assoc "amount" generates) |> Basic.Util.to_int in
  (name, desc, builder, cost, defense, entities, (resource, amount))

let extract_civ assoc =
  let name = (List.assoc "name" assoc) |> Basic.Util.to_string in
  let desc = (List.assoc "desc" assoc) |> Basic.Util.to_string in
  (name, desc)

let extract_entity assoc =
  let name = (List.assoc "name" assoc) |> Basic.Util.to_string in
  let desc = (List.assoc "desc" assoc) |> Basic.Util.to_string in
  let attack = (List.assoc "attack" assoc) |> Basic.Util.to_int in
  let defense = (List.assoc "defense" assoc) |> Basic.Util.to_int in
  let actions = (List.assoc "actions" assoc) |> Basic.Util.to_int in
  let cost = (List.assoc "cost" assoc) |> Basic.Util.to_int in
  let requires = (List.assoc "requires" assoc) |> Basic.Util.to_string in
  Entity.extract_to_role name desc requires cost attack defense actions

let init_json json =
  let meta = json |> Yojson.Basic.Util.member "game"
    |> Basic.Util.to_assoc |> extract_game in
  let entities = List.map extract_entity
    (get_assoc "entities" json) in
  let unlockables = List.map
                    (fun x -> (x, entities)) (get_assoc "techtree" json) in
  let unlockables = List.map extract_unlockable unlockables in
  let branches = List.map fst unlockables in
  let techs = List.map snd unlockables in
  let tree = Research.Research.create_tree branches techs [] in
  let hubs = List.map extract_hub
    (get_assoc "hubs" json) in
  let civs = List.map extract_civ
    (get_assoc "civilizations" json) in
  (meta, unlockables, hubs, civs, entities)

let init_state json : state = {
  (*   let json = Yojson.Basic.from_file json in
       let initialized = init_json json in  *)
  hub_roles = []; (* TODO *)
  entity_roles = []; (* TODO *)
  map = Mapp.generate 0 0;
  screen_top_left = Coord.Screen.create 0 0;
  selected_tile = Coord.origin;
  messages = [];
  is_quit = false;
}

(* [get_next_state s e] is the next state of the game, given the current state
 * [s] and the input event [e] *)
let get_next_state (s:state) = function
  | LTerm_event.Mouse e ->
    (* let new_msg' = Printf.sprintf "Mouse clicked at (%d,%d)" e.col e.row in *)
    (* state.ctx.messages <- new_msg'::state.ctx.messages; *)
    let abs_click_coord =
      Coord.Screen.add
        s.screen_top_left
        (Coord.Screen.create (LTerm_mouse.col e) (LTerm_mouse.row e)) in
    (match Coord.offset_from_screen abs_click_coord with
    | Contained c ->
      let new_msg = Printf.sprintf "Selected tile is now %s" (Coord.to_string c) in
      { s with messages = new_msg::s.messages; selected_tile = c }
    | _ -> s)
  | LTerm_event.Key { code = LTerm_key.Up } ->
    { s with screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create 0 (-1)) }
  | LTerm_event.Key { code = LTerm_key.Down } ->
    { s with screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create 0 1) }
  | LTerm_event.Key { code = LTerm_key.Left } ->
    { s with screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create (-2) 0) }
  | LTerm_event.Key { code = LTerm_key.Right } ->
    { s with screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create 2 0) }
  | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' ->
    { s with is_quit = true }
  | _ -> s

let rec loop ui state_ref =
  let state = !state_ref in
  LTerm_ui.wait ui >>= fun e ->
  let state' = get_next_state state e in
  if state'.is_quit
  then return ()
  else (
    state_ref := state';
    LTerm_ui.draw ui;
    loop ui state_ref)

let main () =
  let (s:state) = init_state () in
  let state_ref = ref s in
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  LTerm_ui.create term (Interface.draw state_ref) >>= fun ui ->
  loop ui state_ref >>= fun () ->
  LTerm.disable_mouse term >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
