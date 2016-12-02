open LTerm_event

type cmd =
  | NoCmd
  | NextTurn
  | Tutorial
  | Describe
  | Research
  | DisplayResearch
  | Skip
  | Move
  | Attack
  | PlaceHub
  | Clear
  | Produce
  | AddEntityToHub
  | SelectTile
  | SelectHub
  | SelectEntity

type required =
  | Tile of Tile.t option
  | HubRole of Hub.role option
  | EntityRole of Entity.role option
  | Research of Research.Research.key option

type t = cmd * required list (* tuple of a cmd and a list of required *)

(* [create c] is a unsatisfied requirements list (every constructor is given
 * None) for the command [c]. *)
let create = function
  | NoCmd           -> (NoCmd          ,[])
  | NextTurn        -> (NextTurn       ,[])
  | Tutorial        -> (Tutorial       ,[])
  | Describe        -> (Describe       ,[])
  | Research        -> (Research       ,[Research (None)])
  | DisplayResearch -> (DisplayResearch,[Research (None)])
  | Skip            -> (Skip           ,[])
  | Move            -> (Move           ,[Tile (None); Tile (None)])
  | Attack          -> (Attack         ,[Tile (None); Tile (None)])
  | PlaceHub        -> (PlaceHub       ,[Tile (None); HubRole (None)])
  | Clear           -> (Clear          ,[Tile (None)])
  | Produce         -> (Produce        ,[Tile (None); EntityRole (None)])
  | AddEntityToHub  -> (AddEntityToHub ,[Tile (None); Tile (None)])
  | SelectTile      -> (SelectTile     ,[])
  | SelectHub       -> (SelectHub      ,[])
  | SelectEntity    -> (SelectEntity   ,[])

(* FIXME: this file has basically been gutted of functionality (parse_event,
 * satisfy_next_req, execute, etc.) because parsing some of the commands depends
 * on the state, and this file cannot have a dependency on the state. I think
 * perhaps the module system could be designed better. *)
