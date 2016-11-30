open Yojson
open Lwt
open CamomileLibrary

type state = State.t
type civ = Civ.t

type parsed_json = {
  turns: int;
  ai: int;
  entities: Entity.role list;
  hubs: Hub.role list;
  civs: (string * string) list;
  tech_tree: Research.Research.research_list;
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
  | _ -> raise (Exception.CriticalError "File does not exist or is not a JSON")

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

let extract_techs entity_role_list hub_role_list assoc =
  let tech = (List.assoc "tech" assoc) |> Basic.Util.to_string in
  let resource = (List.assoc "resource" assoc) |> Basic.Util.to_string in
  let cost = (List.assoc "cost" assoc) |> Basic.Util.to_int in
  let treasure = (List.assoc "treasure" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let treasure = List.nth treasure 0 in
  let hub = (List.assoc "hub" treasure) |> Basic.Util.to_string in
  let amount = (List.assoc "amount" treasure) |> Basic.Util.to_int in
  let entity = extract_list "entity" treasure in
  Research.Research.extract_to_value tech resource cost hub amount
                                      entity entity_role_list hub_role_list

let extract_unlockable entity_role_list hub_role_list assoc =
  let branch = (List.assoc "branch" assoc) |> Basic.Util.to_string in
  let techs = (List.assoc "techs" assoc) |> Basic.Util.to_list
    |> Basic.Util.filter_assoc in
  let techs = List.map (extract_techs entity_role_list hub_role_list) techs in
  (branch, techs)

let extract_hub entity_role_list assoc =
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
  Hub.extract_to_role name desc builder defense cost
                  resource amount entities entity_role_list

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
  let hubs = List.map (extract_hub entities)
    (get_assoc "hubs" json) in
  let unlockables = List.map (extract_unlockable entities hubs)
    (get_assoc "techtree" json) in
  let branches = List.map fst unlockables in
  let techs = List.map snd unlockables in
  let tree = Research.Research.create_tree branches techs [] in
  let civs = List.map extract_civ
    (get_assoc "civilizations" json) in
  {turns = fst meta; ai = snd meta; entities = entities; hubs = hubs;
    tech_tree = tree; civs = civs}

let init_civ player_controlled hub_roles map civ : civ =
  let tup = Cluster.create  ~name:(fst civ)
                              ~descr:"A soon to be booming metropolis"
                              (* TODO this needs to be different *)
                              ~town_hall_tile:(Mapp.get_random_tile !map)
                              ~hub_role_list:hub_roles
                              ~map:!map in
  map := (snd tup);
  {
  name = fst civ;
  desc = snd civ;
  entities = [];
  pending_entities = [];
  pending_hubs = [];
  clusters = [fst tup];
  techs = [];
  player_controlled = player_controlled;
  }

let get_player_start_coords civs =
  let player = List.find (fun civ -> Civ.get_player_controlled civ) civs in
  let cluster = List.nth player.clusters 0 in
  let c = Tile.get_pos (Cluster.get_town_hall cluster) in
  let coord = Coord.screen_from_offset c in
  let origin = List.nth (List.nth coord 0) 0 in
  let offset = Coord.Screen.create (-5) (-2) in
  (c, Coord.Screen.add offset origin)

let init_state json : state =
  let json = Basic.from_file json in
  let parsed = init_json json in
  (* TODO what should these values be? *)
  let map = ref (Mapp.generate 42 42) in
  let civs = List.mapi (fun i x -> init_civ (i=0) parsed.hubs map x)
              parsed.civs in
  let coords = get_player_start_coords civs in
{
  civs = civs;
  turns_left = parsed.turns;
  hub_roles = parsed.hubs;
  entity_roles = parsed.entities;
  tech_tree = parsed.tech_tree;
  map = !map;
  screen_top_left = snd coords;
  selected_tile = fst coords;
  messages = [];
  is_quit = false;
  menu = Menu.main_menu;
  pending_cmd = None;
  current_civ = 0;
}

(* [execute s e c] returns the next state of the game given the current state
 * [s], the input event [e], and the command [c]. *)
let rec execute (s:State.t) e c : State.t =
  match fst c with
  | Cmd.NextTurn        -> s (* TODO *)
  | Cmd.Tutorial        -> s (* TODO *)
  | Cmd.Describe        -> begin
                            let tile = Mapp.tile_by_pos s.selected_tile s.map in
                            let desc = Tile.describe(tile) in
                            {s with messages = desc::s.messages}
                          end
  | Cmd.Research        -> s (* TODO *)
  | Cmd.DisplayResearch -> s (* TODO *)
  | Cmd.Skip            -> s (* TODO *)
  | Cmd.Move            -> s (* TODO *)
  | Cmd.Attack          -> s (* TODO *)
  | Cmd.PlaceHub        -> s (* TODO *)
  | Cmd.Clear           -> begin
                            let tile = Mapp.tile_by_pos s.selected_tile s.map in
                            let entity = Tile.get_entity tile in
                            if entity <> None then
                              if Tile.needs_clearing tile then
                                let tile = Tile.set_terrain tile Tile.Flatland in
                                let map = Mapp.set_tile tile s.map in
                                {s with map = map}
                              else {s with messages =
                                    "No forest to be cleared!"::s.messages}
                            else {s with messages =
                                  "No entity to clear this forest!"::s.messages}
                            end
  | Cmd.Produce         -> begin
                            if Cmd.are_all_reqs_satisfied (snd c) then
(*                               let role = List.nth (snd c) 1 in
                              let role = match role with
                                        | EntityRole x -> begin match x with
                                                        | Some y -> y
                                                        | None -> failwith "lol"
                                                        end
                                        | _ -> failwith "Whoops" in *)
                              let role = List.nth s.entity_roles 0 in
                              let pos = s.selected_tile in
                              let x = Entity.create ~role:role ~pos:pos in
                              s
                            else
                              let tile = Mapp.tile_by_pos
                                          s.selected_tile s.map in
                                          (* TODO fix this *)
                              let req_list = Cmd.satisfy_next_req e (snd c) in
                              let hub = Tile.get_hub tile in
                              match hub with
                              | Some x -> {s with
                                  pending_cmd=Some ((fst c), req_list);
                                  menu=Menu.get_produce_entity_menu x}
                              | None -> {s with
                                  messages = "No hub selected!"::s.messages}
  end
  | Cmd.AddEntityToHub  -> s (* TODO *)
  | Cmd.SelectTile      ->
    let (cmd,req_list) = match s.pending_cmd with
      | Some p -> p
      | None -> failwith "No pending command found when executing Selection" in
    let req_list' = Cmd.satisfy_next_req e req_list in
    if Cmd.are_all_reqs_satisfied req_list'
    then execute { s with pending_cmd=Some (cmd,req_list') } e (cmd,req_list')
    else { s with pending_cmd=Some (cmd,req_list') }
  | SelectHub       -> s (* TODO *)
  | SelectEntity    -> s (* TODO *)

(* [get_next_state s e] is the next state of the game, given the current state
 * [s] and the input event [e] *)
let get_next_state (s:State.t) (e:LTerm_event.t) : State.t = match e with
  (* ------------------------------------------------------------------------- *)
  (* these keys are not affected by the pending command status *)
  | LTerm_event.Key { code = LTerm_key.Up } ->
    { s with screen_top_left =
      Coord.Screen.add s.screen_top_left (Coord.Screen.create 0 (-1)) }
  | LTerm_event.Key { code = LTerm_key.Down } ->
    { s with screen_top_left =
      Coord.Screen.add s.screen_top_left (Coord.Screen.create 0 1) }
  | LTerm_event.Key { code = LTerm_key.Left } ->
    { s with screen_top_left =
      Coord.Screen.add s.screen_top_left (Coord.Screen.create (-2) 0) }
  | LTerm_event.Key { code = LTerm_key.Right } ->
    { s with screen_top_left =
      Coord.Screen.add s.screen_top_left (Coord.Screen.create 2 0) }
  | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' ->
    { s with is_quit = true }
  (* ------------------------------------------------------------------------- *)
  (* mouse events as well as any key that is not one of the above must check for
   * a pending command *)
  (* | LTerm_event.Key { code = c } -> *)
  (*   let f = function *)
  (*     | Some m -> execute s (LTerm_event.Key { code = c }) m.cmd *)
  (*     | None -> s in *)
  (*   s.menu *)
  (*   |> try Some (List.find (fun (x:Menu.t) -> x.key = c)) with Not_found -> None *)
  (*   |> f *)
  (*   |> (fun s -> { s with menu = s.menu.next_menu }) *)
  | LTerm_event.Mouse e ->
    (* let new_msg' = Printf.sprintf "Mouse clicked at (%d,%d)" e.col e.row in *)
    (* state.ctx.messages <- new_msg'::state.ctx.messages; *)
    let f c = match (c,s.pending_cmd) with
      | (Coord.Contained c,Some cmd) ->
        let cmd = Cmd.create Cmd.SelectTile in
        execute s (LTerm_event.Mouse e) cmd
      | (Coord.Contained c,None) ->
        let new_msg = Printf.sprintf "Selected tile is now %s" (Coord.to_string c) in
        { s with messages = new_msg::s.messages; selected_tile = c }
      | (_,_) -> s in
    s.screen_top_left
    |> Coord.Screen.add (Coord.Screen.create (LTerm_mouse.col e) (LTerm_mouse.row e))
    |> Coord.offset_from_screen
    |> f
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
  let (s:state) = init_state "src/game_data.json" in
  let state_ref = ref s in
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  LTerm_ui.create term (Interface.draw state_ref) >>= fun ui ->
  loop ui state_ref >>= fun () ->
  LTerm.disable_mouse term >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
