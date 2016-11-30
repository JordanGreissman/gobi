open State

let attempt_turn s civ =
  civ

let attempt_turns civs (s:State.t) =
  let ai = List.filter (fun x -> not (Civ.get_player_controlled x)) civs in
  let player = List.filter (fun x -> Civ.get_player_controlled x) civs in
  let ai = List.map (attempt_turn s) ai in
  {s with civs = (player@ai)}