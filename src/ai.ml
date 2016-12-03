open State
open Civ
open Cluster
open Tile

let select_random_from_list lst =
  Random.self_init ();
  let x = Random.int (List.length lst) in
  List.nth lst x

let attempt_move_entity s civ =
  if List.length civ.entities = 0 then civ else
  let state = !s in
  let entity = select_random_from_list civ.entities in
  let entity_tile = Mapp.tile_by_pos (Entity.get_pos entity) state.map in
  let tiles = Mapp.get_adjacent_tiles state.map entity_tile in
  let tile = select_random_from_list tiles in
  let tup = Tile.move_entity entity_tile tile in
  let map' = Mapp.set_tile (fst tup) state.map in
  let map' = Mapp.set_tile (snd tup) map' in
  s := {state with map=map'};
  Civ.replace_entity entity civ
 (*  let entities = List.filter (fun x ->
                              (Entity.get_id x) <> (Entity.get_id entity))
                                civ.entities in
  let entities = entity::entities in
  {civ with entities=entities} *)

let attempt_make_technology s civ =
  let state = !s in
  let techs = civ.techs in
  let key = select_random_from_list (List.map (fun (k, v) -> k) techs) in
  let tree_with_unlocked = Research.Research.unlock key techs in
  {civ with techs=tree_with_unlocked}

(* TODO generate certain hub based on turn *)
let attempt_build_hub s civ =
  if List.length civ.clusters = 0 then civ else
  let state = !s in
  let role = select_random_from_list state.hub_roles in
  let cluster = select_random_from_list civ.clusters in
  let tile = select_random_from_list (Cluster.get_tiles cluster) in
  let tiles = Mapp.get_adjacent_tiles state.map tile in
  let tile = select_random_from_list tiles in
  let hub = Hub.create ~role:role
                        ~production_rate:1
                        ~def:(Hub.get_role_default_defense role)
                        ~pos:(Tile.get_pos tile) in
  let new_tile = Tile.place_hub role None tile in
  let map' = Mapp.set_tile new_tile state.map in
  let clusters = Cluster.add_hub civ.clusters map' hub in
  s := {state with map=map'};
  {civ with clusters=clusters}

(* TODO generate certain unit based on turn *)
let attempt_make_entity s civ =
  if List.length civ.clusters = 0 then civ else
  let state = !s in
  let role = select_random_from_list state.entity_roles in
  let cluster = select_random_from_list civ.clusters in
  let tile = select_random_from_list (Cluster.get_tiles cluster) in
  let id = civ.next_id in
  let entity = Entity.create role (Tile.get_pos tile) id in
  let map' = Mapp.set_tile (Tile.set_entity tile (Some entity)) state.map in
  s := {state with map=map'};
  {civ with entities=entity::civ.entities}

let rec attempt_turn s civ =
  Random.self_init ();
  let x = Random.int 10 in
  match x with
  | 0 | 1 -> attempt_make_entity s civ
  | 2 | 3 -> attempt_build_hub s civ
  | 4 | 5 | 6 | 7 -> attempt_move_entity s civ
  | 8 -> attempt_make_technology s civ
  | _ -> civ

let attempt_turns civs (s:State.t ref) =
  let ai = List.filter (fun x -> not (Civ.get_player_controlled x)) civs in
  let player = List.filter (fun x -> Civ.get_player_controlled x) civs in
  let ai = List.map (attempt_turn s) ai in
  {!s with civs = (player@ai)};
