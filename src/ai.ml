open State
open Civ
open Cluster
open Tile

let select_random_from_list lst =
  Random.self_init ();
  let x = Random.int (List.length lst) in
  List.nth lst x

let attempt_move_entity s civ =
  civ

let attempt_technology_victory s civ =
  Random.self_init ();
  let state = !s in
  let x = Random.int ((state.total_turns - state.turn) + 10) in
  if x = 0 then {civ with techs = state.tech_tree}
  else civ

let attempt_build_hub s civ =
  let state = !s in
  let role = select_random_from_list state.hub_roles in
  let cluster = select_random_from_list civ.clusters in
  let tile = select_random_from_list (Cluster.get_tiles cluster) in
  (* TODO pick random adjacent tile, see if its already settled *)
  let tiles = Mapp.get_adjacent_tiles state.map tile in
  let tile = select_random_from_list tiles in
  let hub = Hub.create ~role:role
                        ~production_rate:1
                        ~def:(Hub.get_role_default_defense role)
                        ~pos:(Tile.get_pos tile) in
  let new_tile = Tile.place_hub role None tile in
  let map = Mapp.set_tile new_tile state.map in
  let clusters = Cluster.add_hub civ.clusters state.map hub in
  s := {state with map=map};
  {civ with clusters=clusters}

(* TODO generate certain unit based on turn *)
let attempt_make_entity s civ =
  let state = !s in
  let role = select_random_from_list state.entity_roles in
  let cluster = select_random_from_list civ.clusters in
  let tile = select_random_from_list (Cluster.get_tiles cluster) in
  let id = civ.next_id in
  let entity = Entity.create role (Tile.get_pos tile) id in
  {civ with entities=entity::civ.entities}

let rec attempt_turn s civ =
  Random.self_init ();
  let x = Random.int 10 in
  match x with
  | 0 | 1 -> attempt_make_entity s civ
  | 2 | 3 -> attempt_build_hub s civ
  | 4 | 5 | 6 | 7 -> attempt_move_entity s civ
  | 8 -> attempt_technology_victory s civ
  | _ -> civ

let attempt_turns civs (s:State.t ref) =
  let ai = List.filter (fun x -> not (Civ.get_player_controlled x)) civs in
  let player = List.filter (fun x -> Civ.get_player_controlled x) civs in
  let ai = List.map (attempt_turn s) ai in
  {!s with civs = (player@ai)};
