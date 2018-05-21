open Core_kernel  (* using core_kernel instead of core for js compatibility *)
open Lwt.Infix
open CamomileLibrary
open LTerm_event

open Exception

type civ = Civ.t
type menu = Menu.t

type win_state = Military | Tech | Score | Tie | No_Win

(* TODO: values returned from functions which previously did not return an option
 * before adding Core as a dependency (mostly List functions) have been wrapped
 * in `Option.value_exn` and marked with "FIXME: option". These should be
 * reviewed more carefully and refactored if necessary. *)

let dispatch_message (state:State.t) s k =
  let m = Message.create s k in
  { state with messages = m::state.messages }

let init_civ player_controlled (parsed:Parser.t) map unlocked civ =
  let entity_roles = parsed.entities in
  let hub_roles = parsed.hubs in
  let tech_tree = parsed.tech_tree in
  let starting_tile = Mapp.get_random_tile !map in
  let tiles = Mapp.get_adjacent_tiles !map starting_tile in
  Random.self_init ();
  (* FIXME option *)
  let tile = Option.value_exn (List.nth (tiles) (Random.int (List.length tiles))) in
  let tup = Cluster.create
      ~name:(fst civ)
      ~descr:"A soon-to-be booming metropolis"
      ~town_hall_tile:starting_tile
      ~hub_role_list:hub_roles
      ~map:!map in
  let role = Entity.find_role "worker" entity_roles in
  let worker = Entity.create role (Tile.get_pos tile) 0 in
  let map' = Mapp.set_tile (Tile.set_entity tile (Some worker))
      (snd tup) in
  map := map';
  let temp: Civ.t = {
    name = fst civ;
    desc = snd civ;
    entities = [worker];
    pending_entities = [];
    pending_hubs = [];
    unlocked_entities = [];
    resources = [(Food, 1); (Gold, 1); (Iron, 1); (Paper, 1)];
    clusters = [fst tup];
    techs = tech_tree;
    player_controlled = player_controlled;
    next_id = 1;
  } in
  temp

let get_player_start_coords civs =
  (* FIXME: option *)
  let player = Array.find_exn ~f:Civ.get_player_controlled civs in
  (* FIXME: option *)
  let cluster = Option.value_exn (List.nth player.clusters 0) in
  let c = Tile.get_pos (Cluster.get_town_hall cluster) in
  let coord = Coord.screen_from_offset c in
  (* FIXME: option *)
  let origin = Option.value_exn (List.nth (Option.value_exn (List.nth coord 0)) 0) in
  let offset = Coord.Screen.create (-5) (-2) in
  (c, Coord.Screen.add offset origin)

let init_state json : State.t =
  let parsed = Parser.init_json json in
  let map = ref (Mapp.generate 42 42) in
  let unlocked =
    List.map
      parsed.tech_tree
      (fun (k, v) -> Research.Research.get_unlocked k parsed.tech_tree) in
  (* TODO: no List.flatten in core? *)
  let unlocked = Caml.List.flatten unlocked in
  let mapf i civ = init_civ (i=0) parsed map unlocked civ in
  let civ_list = List.mapi parsed.civs mapf in
  let civs = Array.of_list civ_list in
  let coords = get_player_start_coords civs in
  let temp: State.t = {
    civs = civs;
    turn = 1;
    total_turns = parsed.turns;
    hub_roles = parsed.hubs;
    entity_roles = parsed.entities;
    tech_tree = parsed.tech_tree;
    map = !map;
    screen_top_left = Coord.Screen.add (Coord.Screen.create (-30) (-15)) (snd coords);
    selected_tile = fst coords;
    messages = [];
    is_quit = false;
    is_tutorial = false;
    menu = Menu.main_menu;
    current_civ = Array.get civs 0;
  } in
      temp

let rec add_hubs clusters map hubs =
  match hubs with
  | [] -> clusters
  | h::t -> add_hubs (Cluster.add_hub clusters map h) map t

let check_for_win s = s
  (* let check_conditions (s:State.t) =
   *   (\* TODO *\)
   *   let check_points civs =
   *     let points = List.map civs score in
   *     let rec fold_points i max lst =
   *       match lst with
   *       | [] -> [i]
   *       | h::t -> if h > max then fold_points (i + 1) h t
   *                 else if h = max then (i::(fold_points (i + 1) h t))
   *                 else fold_points i max t in
   *     let indexes = fold_points 0 0 points in
   *     (\* FIXME: option *\)
   *     List.map indexes (fun x -> Option.value_exn (List.nth s.civs x))
   *   in
   * 
   *   let check_tech civs = []
   *     (\* List.filter civs (fun x -> Research.Research.check_complete x.techs) *\)
   *   in
   * 
   *   let rec get_winners civs =
   *     match civs with
   *     | [] -> []
   *     | (Some (x, y))::t -> (x, y)::(get_winners t)
   *     | _ -> raise (Critical ("game","get_winners","Could not get winners"))
   *   in
   * 
   *   let tech_win = let civs = check_tech civs in
   *     match List.length civs with
   *     | 0 -> []
   *     | _ -> List.map
   *              civs (fun (x:Civ.t) -> Some (x.name, x.player_controlled)) in
   *   let military_win = if List.length civs = 1 then
   *       (\* FIXME: option *\)
   *       (let civ = Option.value_exn (List.nth civs 0) in
   *        Some (civ.name, civ.player_controlled))
   *     else None in
   *   let score_win = if s.turn = s.total_turns then
   *       (let civs = check_points civs in
   *        match List.length civs with
   *        | 0 -> []
   *        | _ ->
   *          List.map civs (fun (x:Civ.t) -> Some (x.name, x.player_controlled)))
   *     else [] in
   *   match (score_win, military_win, tech_win) with
   *   | ([], None, []) -> ([], No_Win)
   *   | ((Some (x, y))::t, None, []) -> begin match t with
   *       | [] -> ([(x, y)], Score)
   *       | _ -> (get_winners score_win, Tie)
   *     end
   *   | ([], Some (x, y), []) -> ([(x, y)], Score)
   *   | ([], None, (Some (x, y))::t) ->  begin match t with
   *       | [] -> ([(x, y)], Tech)
   *       | _ -> (get_winners tech_win, Tie)
   *     end
   *   | (a, Some (x, y), []) -> ((x, y)::(get_winners a), Tie)
   *   | ([], Some (x, y), b) -> ((x, y)::(get_winners b), Tie)
   *   | (a, None, b) -> ((get_winners a)@(get_winners b), Tie)
   *   | (a, Some (x, y), b) -> ((x, y)::(get_winners a)@(get_winners b), Tie)
   * in
   * 
   * let conditions_met = check_conditions s in
   * match conditions_met with
   * | (_, No_Win) -> s
   * | (civs, condition) when condition = Tie -> (
   *     dispatch_message s ("Tie game!") Message.Win)
   * | ([(_, player)], condition) -> (
   *   let msg = if player then "You win " else "You lose " in
   *   match condition with
   *   | Military -> (
   *     dispatch_message s (msg^"by a military victory") Message.Win)
   *   | Score -> (
   *     dispatch_message s (msg^"by a score victory") Message.Win)
   *   | Tech -> (
   *     dispatch_message s (msg^"by a technology victory") Message.Win)
   *   | _ -> raise (Critical ("game","check_for_win","Error deciding winner")))(\* or here *\) *)

let place_entity_on_map s entity = entity
  (* let state = !s in
   * let tile = Mapp.tile_by_pos (Entity.get_pos entity) state.map in
   * let tile = Mapp.get_nearest_available_tile tile state.map in
   * let entity = Entity.set_pos (Tile.get_pos tile) entity in
   * let map' = Mapp.set_tile (Tile.set_entity tile (Some entity)) state.map in
   * s := {state with map=map'}; entity *)

let place_hub_on_map s hub = hub
  (* let state = !s in
   * let tile = Mapp.tile_by_pos (Hub.get_position hub) state.map in
   * let map' = Mapp.set_tile (Tile.set_hub tile (Some hub)) state.map in
   * s := {state with map=map'}; hub *)

let tick_pending s civ = civ
  (* let map = s.map in
   * let ticked = List.map civ.pending_entities Entity.tick_cost in
   * let done_entities = List.filter ticked Entity.is_done in
   * let done_entities = List.map done_entities (place_entity_on_map (ref s)) in
   * let entities = done_entities@civ.entities in
   * let pending_entities = List.filter ticked (fun x -> not (Entity.is_done x)) in
   * let ticked = List.map civ.pending_hubs Hub.tick_cost in
   * let done_hubs =
   *   List.map
   *     (List.filter civ.pending_hubs Hub.is_done)
   *     (place_hub_on_map (ref s)) in
   * let clusters = add_hubs civ.clusters map done_hubs in
   * let pending_hubs = List.filter ticked (fun x -> not (Hub.is_done x)) in
   * let civ = get_resource_for_turn civ in
   * {civ with entities=entities;
   *           pending_entities=pending_entities;
   *           clusters=clusters;
   *           pending_hubs=pending_hubs;} *)

let next_turn s = s
  (* let civs = State.get_civs s in
   * let s = (try
   *   Ai.attempt_turns civs (ref s)
   *   with _ -> s) in
   * let civs = List.map (State.get_civs s) (tick_pending s) in
   * let s = check_for_win s in
   * (\* reset the action count of every entity *\)
   * (\* update the civ list *\)
   * (\* TODO: we do not need to keep track of this state twice *\)
   * let civs = List.map
   *   civs 
   *   (fun (civ:Civ.t) ->
   *     let entities = List.map civ.entities (fun e -> Entity.set_actions_used e 0) in
   *     { civ with entities = entities }) in
   * (\* update the map *\)
   * let entities = civs |> List.map ~f:(fun (c:Civ.t) -> c.entities) |> Caml.List.flatten in
   * let map = ref s.map in
   * List.iter
   *   entities
   *   (fun e ->
   *     let pos = Entity.get_pos e in
   *     let tile = Mapp.tile_by_pos pos !map in
   *     let entity = match Tile.get_entity tile with
   *       | Some e -> e
   *       | None -> raise (BadInvariant (
   *                         "game",
   *                         "next_turn",
   *                         "Expected an entity on this tile but there was none")) in
   *     let tile' = Tile.set_entity tile (Some (Entity.set_actions_used entity 0)) in
   *     map := Mapp.set_tile tile' !map);
   * { s with civs = civs; turn = (s.turn + 1); map = !map } *)

(* [execute s e c] returns the next state of the game given the current state
 * [s], the input event [e], and the command [c]. *)
let rec execute (s:State.t) (c:Cmd.t) = match c with
  | NoCmd -> s
  | NextTurn -> next_turn s
  | Tutorial -> { s with is_tutorial = true }
  | Describe str -> begin
    let tile = Mapp.tile_by_pos s.selected_tile s.map in
    match str with
    | "tile" -> dispatch_message s (Tile.describe tile) Message.Info
    | "hub" ->
      let hub = Tile.get_hub tile in
      let s' = match hub with
        | Some h -> dispatch_message s (Hub.describe h) Message.Info
        | None -> raise (Illegal "There is no hub on this tile!") in
      s'
    | "entity" ->
      let entity = Tile.get_entity tile in
      let s' = match entity with
        | Some e -> dispatch_message s (Entity.describe e) Message.Info
        | None -> raise (Illegal "There is no entity on this tile!") in
      s'
    | _ -> s
    end
  (* | Research r -> s
   *   let key = List.nth unwrapped_reqs 0 in
   *     | Research k -> begin
   *         match k with
   *         | Some k -> k
   *         | None   -> raise (BadInvariant (
   *             "game",
   *             "execute",
   *             "All requirements satisfied for Research but requirement is None"))
   *       end
   *     | _ -> raise (BadInvariant (
   *         "game",
   *         "execute",
   *         "Research expected Research requirement but got something else")) in
   *   let civ = State.get_current_civ s in
   *   let key = String.sub key 9 ((String.length key) - 9) in
   *   print_endline key;
   *   let new_civ = Civ.unlock_if_possible key (Civ.get_tree civ) civ in
   *   State.update_civ s.current_civ new_civ s *)
  (* | DisplayResearch t -> (\* TEST THIS *\)
   *   let research_list = List.Assoc.find t s.current_civ.techs in
   *   let desc = Research.Unlockable.describe_unlocked research_list in
   *   let s' = dispatch_message s desc Message.Info in
   *   s' *)
  (* | Skip ->
   *   let tile = Mapp.tile_by_pos s.selected_tile s.map in
   *   let entity = Tile.get_entity tile in
   *   let s' = match entity with
   *     | Some e ->
   *       let entity = Entity.set_actions 0 e in
   *       let new_civ = Civ.replace_entity entity s.current_civ in
   *       State.update_current_civ new_civ
   *     | None -> dispatch_message s "No entity selected!" Message.Illegal in
   *   s' *)
  | Move r ->
    let distance_between_tiles = Tile.distance_between_tiles r.src r.dst in
    let entity_on_tile = Tile.get_known_entity r.src in
    let entity_actions_allowed = Entity.get_actions entity_on_tile in
    let entity_actions_used = Entity.get_actions_used entity_on_tile in
    let moves_used =
      entity_actions_used + (int_of_float distance_between_tiles) in
    let moves_used = if Tile.get_terrain r.dst = Forest
                        then moves_used + 1
                      else moves_used in
    if moves_used <= entity_actions_allowed && not (Tile.has_movement_obstruction r.dst)
    then
      let (src', dst') = Tile.move_entity r.src r.dst in
      let updated_entity = Entity.set_actions_used entity_on_tile moves_used in
      let updated_entity = Entity.set_pos (Tile.get_pos dst') updated_entity in
      let updated_civ = Civ.replace_entity updated_entity s.current_civ in
      (* let state_with_civs_updated = State.update_current_civ updated_civ in *)
      let state_with_civs_updated = s in (* TODO *)
      let map' = s.map |> Mapp.set_tile src' |> Mapp.set_tile (Tile.set_entity dst' (Some updated_entity)) in
      { state_with_civs_updated with map = map' }
    else if moves_used > entity_actions_allowed then
      raise (Illegal ("This entity does not have enough remaining actions!"))
    else raise (Illegal ("You cannot move to this tile!"))
  (* | Attack r ->
   *   let adjacent_tiles = Mapp.get_adjacent_tiles s.map r.attacker in
   *   let is_adjacent_tile = List.mem r.target adjacent_tiles in
   *   let entity_on_tile = Tile.get_entity r.target in
   *   let hub_on_tile = Tile.get_hub r.target in
   *   begin
   *     match (entity_on_tile,hub_on_tile) with
   *     | (Some entity, Some hub) -> raise (Illegal "umm there shouldnt be a hub and an entity")
   *     | (Some entity, None) ->
   *       let combat_result = Combat.attack_entity r.attacker r.target in
   *       if combat_result then
   *         let target = Tile.set_entity r.target None in
   *         let current_civ = State.get_current_civ s in
   *         let updated_civ = Civ.remove_entity entity current_civ in
   *         let updated_civs_state = State.update_civ s.current_civ updated_civ s in
   *         let map' = s.map |> Mapp.set_tile target in
   *         {updated_civs_state with map=map';}
   *       else
   *         let attacker = Tile.set_entity r.attacker None in
   *         let current_civ = State.get_current_civ s in
   *         let updated_civ = Civ.remove_entity entity current_civ in
   *         let updated_civs_state = State.update_civ s.current_civ updated_civ s in
   *         let map' = s.map |> Mapp.set_tile attacker in
   *         {updated_civs_state with map=map';}
   *     | (None, Some hub) ->
   *       let combat_result = Combat.attack_hub r.attacker r.target in
   *       if combat_result
   *       then
   *         let target = Tile.set_entity r.target None in
   *         let map' = s.map |> Mapp.set_tile target in
   *         {s with map=map';}
   *       else (\*SUBTRACT ATTACKER ATTACK FROM HUB DEFENSE*\)
   *         let attacker_attack = Entity.get_attack (Tile.get_known_entity r.attacker) in
   *         let updated_hub = Hub.change_defense attacker_attack hub in
   *         let target = Tile.set_hub r.target (Some updated_hub) in
   *         let map' = s.map |> Mapp.set_tile target in
   *         {s with map=map';}
   *     | (None, None) -> raise (Illegal "You cannot attack this tile")
   *   end *)
  (* | PlaceHub r ->
   *   if (Tile.is_settled r.tile) then raise (Illegal "You cannot place a hub on a pre-existing hub")
   *   else if not (Tile.is_entity_worker r.tile) then raise (Illegal "You can only build a hub with a worker")
   *   else
   *   let starting_entity = None in (\* TODO *\)
   *   let civ = get_current_civ s in
   *   let hub = Hub.create ~role:r.role
   *                         ~production_rate:1
   *                         ~def:(Hub.get_role_default_defense r.role)
   *                         ~pos:(Tile.get_pos r.tile) in
   *   let clusters = Cluster.add_hub civ.clusters s.map hub in
   *   let t' = Tile.place_hub r.role starting_entity r.tile in
   *   let map' = Mapp.set_tile t' s.map in
   *   let civ = {civ with clusters=clusters} in
   *   let s = update_civ s.current_civ civ s in
   *   let updated_state = { s with map = map' } in
   *   dispatch_message
   *     { s with map = map' }
   *     ((Hub.get_role_name r.role) ^ " now under construction")
   *     Message.Info *)
  | Clear ->
    let tile = Mapp.tile_by_pos s.selected_tile s.map in
    let s' = match Tile.get_entity tile with
      | Some e ->
        (* TODO pretty sure Tile.clear already does all this checking and error handling... *)
        if Tile.needs_clearing tile then
          let tile = Tile.set_terrain tile Tile.Flatland in
          let map = Mapp.set_tile tile s.map in
          {s with map = map}
        else dispatch_message s "No forest to be cleared!" Message.Illegal
      | None ->
        dispatch_message s "No entity to clear this forest!" Message.Illegal in
    s'
  (* | Produce r ->
   *   (\* TODO Produce requires a Hub role and an Entity role, but here we only use
   *    * the entity role, because the entity production menu only displays the entities
   *    * that can be produced for the selected hub role, so really we've already
   *    * eliminated the possibility that we're producing an entity role that's
   *    * illegal for this hub role and we don't have to check it twice *\)
   *   let entity = Entity.create r.role s.selected_tile s.current_civ.next_id in
   *   let civ = {s.current_civ with pending_entities = entity::s.current_civ.pending_entities} in
   *   let s' = State.update_current_civ civ in
   *   dispatch_message
   *     s'
   *     ("One "^(Entity.get_role_name r.role)^" is now in production")
   *     Message.Info *)
  (* | AddEntityToHub r ->
   *   let civ' = Civ.add_entity_to_hub r.entity r.hub (List.nth s.civs s.current_civ) in
   *   let s' = State.update_civ s.current_civ civ' s in
   *   dispatch_message s' "Entity added to hub" Message.Info *)
  | _ -> s (* TODO: remove this catch-all *)
  (* | SelectTile | SelectHub | SelectEntity -> *)
  (*   let (cmd,req_list) = match s.pending_cmd with *)
  (*     | Some p -> p *)
  (*     | None -> raise (BadInvariant ( *)
  (*         "game", *)
  (*         "execute", *)
  (*         "No pending command found when executing SelectTile")) in *)
  (*   let req_list' = satisfy_next_req e s req_list in *)
  (*   if are_all_reqs_satisfied req_list' *)
  (*   then execute { s with pending_cmd = None } e (cmd,req_list') *)
  (*   else { s with pending_cmd=Some (cmd,req_list') } *)

(* TODO: rename *)
(* let temp_f =
 *   Cmd.get_next_unsatisfied_req reqs >>= (function
 *   | `HubRole ->
 *     Hub.find_role m.text s.hub_roles >>= fun l ->
 *     List.hd l >>= function
 *     | Ok r -> HubRole r
 *     | Err s -> failwith s
 *   | `EntityRole ->
 *     Entity.find_role m.text s.entity_roles >>= function
 *     | Ok r -> EntityRole r
 *     | Err s -> failwith s
 *   | `Research -> Research m.text
 *   | `Tile -> raise (Illegal ("Please " ^ (expected_action a))))
 *   >>= (function
 *   | Some s -> s
 *   | None -> failwith "Invariant")
 * 
 *   let (satisfied,req,unsatisfied) = Cmd.get_next_unsatisfied_req reqs in
 *   let req' = match req with
 *   | HubRole _ ->
 *     let role_lst = Hub.find_role m.text s.hub_roles in
 *     begin match List.length role_lst with
 *     | 0 -> raise (BadInvariant (
 *         "game",
 *         "parse_event",
 *         "No hub role is associated with the menu item with text: "^m.text))
 *     | 1 -> HubRole (Some (List.hd_exn role_lst))
 *     | n -> raise (Critical (
 *         "game",
 *         "parse_event",
 *         "Duplicate rolls \"" ^ m.text ^ "\"exist!" ))
 *     end
 *   | EntityRole _ ->
 *     let e =
 *       try Entity.find_role m.text s.entity_roles
 *       with Illegal _ -> raise (Critical (
 *           "game",
 *           "parse_event",
 *           "Entity role \"" ^ m.text ^ "\" not found")) in
 *     EntityRole (Some e)
 *   | Research _ -> Research (Some m.text)
 *   (\* here we want to dispatch an error message instead of raising an exception *\)
 *   | Tile _ as a ->  in
 *   (s,Some (cmd,satisfied @ [req'] @ unsatisfied)) in *)

(* TODO: documentation out of date *)
(* [get_next_state s e] is the next state of the game, given the current state
 * [s] and the input event [e] *)
let parse_input_event s pc e = (s,pc)
  (* let expected_action = function
   *   | Tile _ -> "select a tile"
   *   | HubRole _ -> "select a hub type to build"
   *   | EntityRole _ -> "select an entity type to produce"
   *   | Research _ -> "select a research upgrade" in
   * match e with
   * (\* ------------------------------------------------------------------------- *\)
   * (\* these keys are not affected by the pending command status *\)
   * | LTerm_event.Key { code = Up } ->
   *   ({ s with
   *      screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create 0 (-1));
   *    },
   *    pc)
   * | LTerm_event.Key { code = Down } ->
   *   ({ s with
   *      screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create 0 1)
   *    },
   *    pc)
   * | LTerm_event.Key { code = Left } ->
   *   ({ s with
   *      screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create (-2) 0)
   *    },
   *    pc)
   * | LTerm_event.Key { code = Right } ->
   *   ({ s with
   *      screen_top_left = Coord.Screen.add s.screen_top_left (Coord.Screen.create 2 0)
   *    },
   *    pc)
   * | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' ->
   *   ({ s with is_quit = true },pc)
   * | LTerm_event.Key { code = Escape } -> ({ s with is_tutorial = false },pc)
   * (\* ------------------------------------------------------------------------ *\)
   * (\* mouse events as well as any key that is not one of the above must check for
   *  * a pending command *\)
   * | LTerm_event.Key k ->
   *   List.find s.menu (fun (x:menu) -> x.key = k.code) >>= (fun m ->
   *   pc >>= (fun (cmd,reqs) ->
   *   (\* let updated_reqs = temp_f s cmd reqs in *\) (\* TODO *\)
   *   let next_menu = match m.next_menu with
   *     | NoMenu -> s.menu
   *     | StaticMenu m -> m
   *     | TileMenu f -> f (Mapp.tile_by_pos s.selected_tile s.map)
   *     | BuildHubMenu f -> f s.hub_roles
   *     | ProduceEntityMenu f -> (
   *       match Tile.get_hub (Mapp.tile_by_pos s.selected_tile s.map) with
   *       | Some h -> f h
   *       | None   -> raise (Illegal "No hub selected!"))
   *     | NextResearchMenu f ->
   *       (\* The text of the menu item serves to identify the tech tree branch
   *         * the user selected *\)
   *       f s.tech_tree m.text in
   *   (\* ({ s with menu = next_menu },(cmd,updated_reqs)))) *\)
   *   ({ s with menu = next_menu },(cmd,reqs))))
   *   >>= function
   *   | Some s -> s
   *   | None -> (s,pc)
   *   (\* let parse_key_event (k:LTerm_key.t) f = *\)
   *   (\*   match List.find s.menu (fun (x:menu) -> x.key = k.code) with *\)
   *   (\*   | None -> (s,pc) *\)
   *   (\*   | Some m -> f m in *\)
   *   (\* parse_key_event k (fun (m:Menu.t) -> *\)
   *   (\*   let (s',pc') = match pc with *\)
   *   (\*     | None -> (s,pc) *\)
   *   (\*     | Some (cmd,reqs) -> (s,pc) in *\)
   * 
   *   (\*   let next_menu = match m.next_menu with *\)
   *   (\*     | NoMenu -> s.menu *\)
   *   (\*     | StaticMenu m -> m *\)
   *   (\*     | TileMenu f -> f (Mapp.tile_by_pos s.selected_tile s.map) *\)
   *   (\*     | BuildHubMenu f -> f s.hub_roles *\)
   *   (\*     | ProduceEntityMenu f -> ( *\)
   *   (\*       match Tile.get_hub (Mapp.tile_by_pos s.selected_tile s.map) with *\)
   *   (\*       | Some h -> f h *\)
   *   (\*       | None   -> raise (Illegal "No hub selected!")) *\)
   *   (\*     | NextResearchMenu f -> *\)
   *   (\*       (\\* The text of the menu item serves to identify the tech tree branch *\)
   *   (\*        * the user selected *\\) *\)
   *   (\*       f s.tech_tree m.text in *\)
   *   (\*   ({ s with menu = next_menu },pc')) *\)
   * | LTerm_event.Mouse e ->
   *   s.screen_top_left
   *   |> Coord.Screen.add (Coord.Screen.create ((LTerm_mouse.col e)-20) (LTerm_mouse.row e))
   *   |> Coord.offset_from_screen
   *   |> function
   *     | (Coord.Contained c,Some (cmd,reqs)) ->
   *       let (satisfied,req,unsatisfied) = Cmd.get_next_unsatisfied_req (cmd,reqs) in
   *       let req' = match req with
   *         | Tile _ -> Tile (Some (Mapp.tile_by_pos c s.map))
   *         (\* here we want to dispatch an error message instead of raising an exception *\)
   *         | a -> raise (Illegal ("Please " ^ (expected_action a))) in
   *       ({ s with selected_tile = c },Some (cmd,satisfied @ [req'] @ unsatisfied))
   *     | (Coord.Contained c,None) ->
   *       (\* let s' = dispatch_message *\)
   *       (\*     s *\)
   *       (\*     (Printf.sprintf "Selected tile is now %s" (Coord.to_string c)) *\)
   *       (\*     Message.Info in *\)
   *       ({ s with selected_tile = c },None)
   *     | (_,_) -> (s,pc)
   * | _ -> (s,pc) *)

let rec player_loop ui state_ref pending_cmd =
  let try_parse_input_event e (state:State.t) (pending_cmd:Cmd.t) : State.t * Cmd.t =
    try parse_input_event state pending_cmd e with
    | Illegal s -> (dispatch_message state s Message.Illegal,pending_cmd)
    | Critical (file,func,err) ->
      failwith (Printf.sprintf "Critical error in %s.ml:%s: %s" file func err)
    | BadInvariant (file,func,err) ->
      failwith (Printf.sprintf "Invariant violation in %s.ml:%s: %s" file func err) in
  let exec_if_reqs_satisifed (state:State.t) (pending_cmd:Cmd.t) = (state, pending_cmd) in
    (* if Cmd.are_all_reqs_satisfied pending_cmd then
     *   execute state pending_cmd
     * else
     *   (state,pending_cmd) in *)
  let state = !state_ref in
  LTerm_ui.wait ui >>= fun e ->
  let state = !state_ref in
  let (state, pending_cmd') = try_parse_input_event e state pending_cmd in
  let (state, pending_cmd') = exec_if_reqs_satisifed state pending_cmd' in
  if state.is_quit (* End more gracefully? *) then
    Lwt.return ()
  else begin
    state_ref := state;
    LTerm_ui.draw ui;
    player_loop ui state_ref pending_cmd'
  end

let main () =
  let s = init_state "res/json/game_data.json" in
  let state_ref = ref s in
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  LTerm_ui.create term (Interface.draw state_ref) >>= fun ui ->
  player_loop ui state_ref Cmd.NoCmd >>= fun () ->
  LTerm.disable_mouse term >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
