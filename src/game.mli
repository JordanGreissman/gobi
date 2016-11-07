
(* state contains all the information about the game.
 * Turns modify the state and return a new state for the game. *)
type state

(* [make_move] computes the state after one action *)
val make_move : state -> state

(* [turn] computes the state after a player's entire turn *)
val turn : state -> state

(* [init_state] returns a state that represents the game defined
 * by the inputted json *)
val init_state : json -> state

(* [load_json] returns a json loaded from string *)
val load_json : string -> json

(* [main] computes the state based on given difficulty level *)
val main : string -> state