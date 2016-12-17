open Core.Std
open LTerm_event
open Exception

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

let is_satisfied = function
  | Tile x -> Option.is_some x
  | HubRole x -> Option.is_some x
  | EntityRole x -> Option.is_some x
  | Research x -> Option.is_some x

let are_all_reqs_satisfied lst =
  List.fold_left lst true (fun a x -> a && (is_satisfied x))

let rec get_next_unsatisfied_req reqs =
  let (satisfied_reqs,xs) = List.split_while reqs is_satisfied in
  try
    let (r,unsatisfied_reqs) = (List.hd_exn xs,List.tl_exn xs) in
    (satisfied_reqs,r,unsatisfied_reqs)
  with _ -> raise (BadInvariant (
    "game",
    "satisfy_next_req",
    "All requirements already satisfied!"))
