(**pass in Two tiles. Attacker tile and defender tile and get_entity and get_hub**)


let compute_weights attack defend =
  let attackFloat = float_of_int attack in
  let defendFloat = float_of_int defend in
  let percent = (attackFloat /. (attackFloat +. defendFloat)) *. 100. in
  int_of_float percent

let get_random_number =
let _ = Random.self_init () in
Random.int 100

let attack_hub attack_tile hub_tile =
  let entity_attack = Entity.get_attack (Tile.get_entity attack_tile) in
  let hub_defense = Hub.get_defense (Tile.get_hub hub_tile) in
  let computed_weights = compute_weights entity_attack hub_defense in
  let random_number = get_random_number in
  if computed_weights > random_number
  then
    if hub_defense - entity_atack > 0
    then true
    else let new_hub = Hub.change_defense (-entity_attack) (Tile.get_hub hub_tile) in
      let _ = Tile.set_hub hub_tile new_hub in
      false
  else false

let attack_entity attack_tile defend_tile =
  let entity_attack = Entity.get_attack (Tile.get_entity attack_tile) in
  let entity_defense = Entity.get_defense (Tile.get_entity defend_tile) in
  let computed_weights = compute_weights entity_attack entity_defense in
  let random_number = get_random_number in
  computed_weights > random_number
