(** Combat is represented by the system generating a random number, x,
 * and computing weight, w. Weight is computed as 100*(a / (a + d)), where
 * a is the attacking unit's attack value and d is the defending unit's 
 * defense value. 
 *
 * Entity-entity combat:
 * If x < w, then the attacker wins, the defender is destroyed, and the 
 * function returns true. The attacker then occupies the tile previously 
 * held by the defender.
 * 
 * Else, the defender wins, the attacker is destroyed, and the function 
 * returns false. The defender does not move tiles.
 * 
 *
 * Entity-hub combat:
 * If x < w, then the hub loses an amount of defense equal to a. If the
 * hub defense < 0, then the attacker wins and the function returns true.
 * The hub is destroyed and the attacker occupies the tile previously
 * held by the hub.
 * 
 * Else, the defender wins, and the function returns false. The attacker
 * is not destroyed. *)

(* [compute_weights] returns an int, 1..100, that represents the
 * attacking unit's weight in this instance of combat 
 *
 * Note that ints have to be converted into floats in order to properly
 * compute the weight, and then weight has to be converted back into int *)
val compute_weights : int -> int -> int

(** [attack_hub] returns true if the attacking unit
 * destroys the building, false otherwise
 * 
 * Example: 
 *    Soldier {Attack: 5, Defense: 3}
 *    TownHall {Attack: 1, Defense: 3}
 *    
 *    Solider attacks TownHall
 *    
 *    compute_weights 5 (5 + 3) -> 63
 *    
 *    Generate random number between 1..100 -> 41
 *    63 > 41, TownHall.defense := 3 - 5 
 *    TownHall.defense < 0, attack wins and hub is destroyed 
 *    
 *    Returns true *)
val attack_hub : int -> int -> bool

(** [attack_entity] returns true if the attacking unit wins
 * and false otherwise 
 * 
 * Example: 
 *    Soldier {Attack: 5, Defense: 3}
 *    HorseDude {Attack: 1, Defense: 12}
 *    
 *    Solider attacks HorseDude
 *    
 *    compute_weights 5 (5 + 12) -> 29
 *    
 *    Generate random number between 1..100 -> 35
 *    29 < 35, defense wins and attack is destroyed 
 *
 *    Returns false *)
val attack_entity : int -> int -> bool
