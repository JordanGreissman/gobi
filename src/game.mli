(* open Cluster *)
(* open Combat *)
(* open Ai *)
(* open Tile *)
(* open Map *)
(* open Interface *)
(* open Research *)
open Yojson

(* state contains all the information about the game.
 * Turns modify the state and return a new state for the game. 
 * State will be represented as a record *)
type state

(* cmd contains a standardized form of what the user wants to do
 * for a given move *)
type cmd = {
  verb: string;
  obj: string;
}

(* [make_move] computes the state after one action *)
val make_move : state -> cmd -> state

(* [parse_input] returns a command based on use input *)
val parse_input : string -> cmd

(* [turn] computes the state after a player's entire turn *)
val turn : state -> state

(* [init_state] returns a state that represents the game defined
 * by the inputted json *)
val init_state : json -> state

(* [load_json] returns a json loaded from string *)
val load_json : string -> json

(* [main] computes the state based on given difficulty level *)
val main : string -> state
