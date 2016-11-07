open cluster

(* [compute_weights] returns an int, 1..100, that represents the
 * attacking unit's weight in this instance of combat *)
val compute_weights : int -> int -> int

(* [attack_unit] returns true if the attacking unit wins
 * and false otherwise *)
val attack_unit : int -> int -> bool