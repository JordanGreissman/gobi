(* open Cluster *)
(* open Combat *)
(* open Ai *)
(* open Tile *)
open Mapp
(* open Interface *)
(* open Research *)
open Yojson
open Lwt
open CamomileLibrary

(* type civ = {
  name : string;
  entities : entity list;
  clusters : cluster list;
  player_controlled : boolean;
} *)

type state = {
 (*  civs : civ list;
  turns_left : int; *)
  mutable ctx : Interface.draw_context;
}

type cmd = {
  verb : string;
  obj : string;
}

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

let extract_techs assoc =
  let tech = (List.assoc "tech" assoc) |> Basic.Util.to_string in
  let resource = (List.assoc "resource" assoc) |> Basic.Util.to_string in
  let cost = (List.assoc "cost" assoc) |> Basic.Util.to_int in
  let treasure = (List.assoc "treasure" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let treasure = List.nth treasure 0 in
  let hub = (List.assoc "hub" treasure) |> Basic.Util.to_string in
  let amount = (List.assoc "amount" treasure) |> Basic.Util.to_int in
  let entity = extract_list "entity" treasure in
  (tech, resource, cost, (hub, amount, entity))

let extract_unlockable assoc =
  let branch = (List.assoc "branch" assoc) |> Basic.Util.to_string in
  let techs = (List.assoc "techs" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let techs = List.map extract_techs techs in
  (branch, techs)

let extract_hub assoc =
  let name = (List.assoc "name" assoc) |> Basic.Util.to_string in
  let desc = (List.assoc "desc" assoc) |> Basic.Util.to_string in
  let builder = (List.assoc "built by" assoc) |> Basic.Util.to_string in
  let upgrades = (List.assoc "upgrades to" assoc) |> Basic.Util.to_string in
  let health = (List.assoc "health" assoc) |> Basic.Util.to_int in
  let entities = extract_list "entities" assoc in
  let generates = (List.assoc "generates" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let generates = List.nth generates 0 in
    let resource = (List.assoc "resource" generates) |> Basic.Util.to_string in
    let amount = (List.assoc "amount" generates) |> Basic.Util.to_int in
  (name, desc, builder, upgrades, health, entities, (resource, amount))

let extract_civ assoc =
  let name = (List.assoc "name" assoc) |> Basic.Util.to_string in
  let desc = (List.assoc "desc" assoc) |> Basic.Util.to_string in
  (name, desc)

let extract_entity assoc =
  let name = (List.assoc "name" assoc) |> Basic.Util.to_string in
  let desc = (List.assoc "desc" assoc) |> Basic.Util.to_string in
  let can_attack = (List.assoc "can attack" assoc) |> Basic.Util.to_bool in
  let builds = extract_list "builds" assoc in
  let attack = (List.assoc "attack" assoc) |> Basic.Util.to_int in
  let defense = (List.assoc "defense" assoc) |> Basic.Util.to_int in
  let actions = (List.assoc "actions" assoc) |> Basic.Util.to_int in
  let requires = (List.assoc "requires" assoc) |> Basic.Util.to_string in
  (name, desc, can_attack, builds, attack, defense, actions, requires)

let init_json json =
  let meta = json |> Yojson.Basic.Util.member "game"
    |> Basic.Util.to_assoc |> extract_game in
  let unlockables = List.map extract_unlockable
    (get_assoc "techtree" json) in
  let hubs = List.map extract_hub
    (get_assoc "hubs" json) in
  let civs = List.map extract_civ
    (get_assoc "civilizations" json) in
  let entities = List.map extract_entity
    (get_assoc "entities" json) in
  (meta, unlockables, hubs, civs, entities)

let init_state json =
(*   let json = Yojson.Basic.from_file json in
  let initialized = init_json json in  *)
  {
  (* TODO: what are the width and height params to generate? *)
  ctx = {
    top_left = Coord.Screen.create 0 0;
    map = Mapp.generate 0 0;
    (* selected = Coord.origin; *)
    selected = Coord.create 1 1;
    messages = [ "This is a test message" ];
  };
}

let rec loop ui state =
  LTerm_ui.wait ui >>= function
  | LTerm_event.Mouse e ->
    (* let new_msg' = Printf.sprintf "Mouse clicked at (%d,%d)" e.col e.row in *)
    (* state.ctx.messages <- new_msg'::state.ctx.messages; *)
    let abs_click_coord = Coord.Screen.add state.ctx.top_left (Coord.Screen.create e.col e.row) in
    (match Coord.offset_from_screen abs_click_coord with
    | Contained c ->
      state.ctx.selected <- c;
      let new_msg = Printf.sprintf "Selected tile is now %s" (Coord.to_string c) in
      state.ctx.messages <- new_msg::state.ctx.messages
    | _ -> ());
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Up } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create 0 (-1));
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Down } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create 0 1);
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Left } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create (-2) 0);
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Right } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create 2 0);
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' -> return ()
  | _ ->
    LTerm_ui.draw ui;
    loop ui state

let main () =
  let state = init_state () in
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  LTerm_ui.create term (Interface.draw state.ctx) >>= fun ui ->
  loop ui state >>= fun () ->
  LTerm.disable_mouse term >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
