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
  | Tile of Coord.t option
  | HubRole of LTerm_key.t option
  | EntityRole of LTerm_key.t option
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
  | PlaceHub        -> (PlaceHub       ,[Tile (None); HubRole    (None)])
  | Clear           -> (Clear          ,[Tile (None)])
  | Produce         -> (Produce        ,[Tile (None); EntityRole (None)])
  | AddEntityToHub  -> (AddEntityToHub ,[Tile (None); Tile (None)])
  | SelectTile      -> (SelectTile     ,[])
  | SelectHub       -> (SelectHub      ,[])
  | SelectEntity    -> (SelectEntity   ,[])


(* given an unsatisfied requirement [r] and an input event [e], return a
 * satisfied version of [r] where the parameter comes from parsing [e]. *)
let parse_event r e =
  let get_req_name = function
    | Tile _       -> "Tile"
    | HubRole _    -> "HubRole"
    | EntityRole _ -> "EntityRole"
    | Research _   -> "Research" in
  let get_expected_event = function
    | Tile _        -> "MouseEvent"
    | HubRole _     -> "KeyEvent"
    | EntityRole _  -> "KeyEvent"
    | Research _    -> "none" in
  let get_event_name = function
    | Resize _   -> "ResizeEvent"
    | Key _      -> "KeyEvent"
    | Sequence _ -> "SequenceEvent"
    | Mouse _    -> "MouseEvent" in
  match (r,e) with
  | (Tile _,Mouse m) -> (* get the tile at screen coord [m] *)
    let f c = match Coord.offset_from_screen c with
      | Contained c -> Tile (Some c)
      | _ -> raise (Expception.Illegal "Not Contained in parse_event") in
    let x,y = (LTerm_mouse.col m,LTerm_mouse.row m) in
    let c = Coord.Screen.create x y in
    f c
  | (HubRole _,Key k) -> HubRole (Some k)
  | (EntityRole _,Key k) -> EntityRole (Some k)
  | (_,_) -> raise (Expception.Illegal (Printf.sprintf
                    "Requirement %s expected input event %s put got %s instead"
                    (get_req_name r)
                    (get_expected_event r)
                    (get_event_name e)))

let is_some = function
  | Some x -> true
  | None   -> false

let is_satisfied = function
  | Tile x       -> is_some x
  | HubRole x    -> is_some x
  | EntityRole x -> is_some x
  | Research x   -> is_some x

let rec satisfy_next_req e = function
  | []   -> failwith "All requirements already satisfied!"
  | h::t ->
    if is_satisfied h
    then h::(satisfy_next_req e t)
    else (parse_event h e)::t

let are_all_reqs_satisfied lst =
  List.fold_left (fun a x -> a && (is_satisfied x)) true lst
