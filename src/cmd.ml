open LTerm_event

type cmd =
  | NoCmd
  | NextTurn
  | Tutorial
  | Describe of string
  | Research
  | DisplayResearch
  | Skip
  | Move
  | Attack
  | PlaceHub
  | Clear
  | Produce
  | AddEntityToHub
  (* | SelectTile *)
  (* | SelectHub *)
  (* | SelectEntity *)

type requirement =
  | Tile of Tile.t option
  | HubRole of Hub.role option
  | EntityRole of Entity.role option
  | Research of Research.Research.key option

type t = cmd * requirement list (* tuple of a cmd and a list of requirement options *)

(* [create c] is a unsatisfied requirements list (every constructor is given
 * None) for the command [c]. *)
let create = function
  | NoCmd           -> (NoCmd          ,[])
  | NextTurn        -> (NextTurn       ,[])
  | Tutorial        -> (Tutorial       ,[])
  | Describe s      -> (Describe s     ,[])
  | Research        -> (Research       ,[Research (None)])
  | DisplayResearch -> (DisplayResearch,[Research (None)])
  | Skip            -> (Skip           ,[])
  | Move            -> (Move           ,[Tile (None); Tile (None)])
  | Attack          -> (Attack         ,[Tile (None); Tile (None)])
  | PlaceHub        -> (PlaceHub       ,[Tile (None); HubRole (None)])
  | Clear           -> (Clear          ,[Tile (None)])
  | Produce         -> (Produce        ,[HubRole (None); EntityRole (None)])
  | AddEntityToHub  -> (AddEntityToHub ,[Tile (None); Tile (None)])
  (* | SelectTile      -> (SelectTile     ,[]) *)
  (* | SelectHub       -> (SelectHub      ,[]) *)
  (* | SelectEntity    -> (SelectEntity   ,[]) *)

let is_some = function
  | Some x -> true
  | None   -> false

let is_satisfied r =
  match r with
  | Tile x       -> is_some x
  | HubRole x    -> is_some x
  | EntityRole x -> is_some x
  | Research x   -> is_some x

let are_all_reqs_satisfied lst =
  List.fold_left (fun a x -> a && (is_satisfied x)) true lst

(* ========================= COMMAND IMPLEMENTATIONS ========================= *)

let next_turn s = s
let describe s = s
let research s = s
let display_research s = s
let skip s = s
let move s = s
let attack s = s
let place_hub s = s
let clear s = s
let produce s = s
let add_entity_to_hub s = s

(* ======================= END COMMAND IMPLEMENTATIONS ======================= *)

let get_execute_f = function
  | NoCmd           -> (fun s -> s)
  | NextTurn        -> next_turn
  | Tutorial        -> (fun s -> { s with is_tutorial = true })
  | Describe s      -> describe
  | Research        -> research
  | DisplayResearch -> display_research
  | Skip            -> skip
  | Move            -> move
  | Attack          -> attack
  | PlaceHub        -> place_hub
  | Clear           -> clear
  | Produce         -> produce
  | AddEntityToHub  -> add_entity_to_hub

let execute s cmd = (get_execute_f cmd) s

