open Core_kernel
open LTerm_event
open Exception

type t =
  | NoCmd
  | NextTurn
  | Tutorial
  | Describe of string
  | Research of Research.Research.key
  | DisplayResearch of Research.Research.key
  | Skip
  | Move of { src: Tile.t; dst: Tile.t }
  | Attack of { attacker: Tile.t; target: Tile.t }
  | PlaceHub of { role: Hub.role; pos: Tile.t }
  | Clear
  | Produce of { role: Entity.role; hub: Tile.t }
  | AddEntityToHub of { entity: Tile.t; hub: Tile.t }
  (* | SelectTile *)
  (* | SelectHub *)
  (* | SelectEntity *)

type cmd = [ `NoCmd | `NextTurn | `Tutorial | `Describe of string | `Research |
             `DisplayResearch | `Skip | `Move | `Attack | `PlaceHub | `Clear |
             `Produce | `AddEntityToHub ]
type unsatisfied_req = [ `Tile | `HubRole | `EntityRole | `Research ]
type satisfied_req =
  | Tile of Tile.t
  | HubRole of Hub.role
  | EntityRole of Entity.role
  | Research of Research.Research.key

type pending = cmd * unsatisfied_req list * satisfied_req list

(* [create c] is a unsatisfied requirements list (every constructor is given
 * None) for the command [c]. *)
let create = function
  | `NoCmd           -> (`NoCmd          ,[],[])
  | `NextTurn        -> (`NextTurn       ,[],[])
  | `Tutorial        -> (`Tutorial       ,[],[])
  | `Describe s      -> (`Describe s     ,[],[])
  | `Research        -> (`Research       ,[`Research],[])
  | `DisplayResearch -> (`DisplayResearch,[`Research],[])
  | `Skip            -> (`Skip           ,[],[])
  | `Move            -> (`Move           ,[`Tile; `Tile],[])
  | `Attack          -> (`Attack         ,[`Tile; `Tile],[])
  | `PlaceHub        -> (`PlaceHub       ,[`Tile; `HubRole],[])
  | `Clear           -> (`Clear          ,[`Tile],[])
  | `Produce         -> (`Produce        ,[`HubRole; `EntityRole],[])
  | `AddEntityToHub  -> (`AddEntityToHub ,[`Tile; `Tile],[])
  (* | SelectTile      -> (SelectTile     ,[]) *)
  (* | SelectHub       -> (SelectHub      ,[]) *)
  (* | SelectEntity    -> (SelectEntity   ,[]) *)

(* TODO all the boilerplate in the requirements system has been reduced to this
 * function, but I wonder whether more advanced type-foo could get rid of this
 * boilerplate too *)
let t_of_pending (c,u,s) = match c with
  | `NoCmd -> NoCmd
  | `NextTurn -> NextTurn
  | `Tutorial -> Tutorial
  | `Describe s -> Describe s
  | `Research ->
    let key = match Option.value_exn (List.nth s 0) with Research r -> r | _ -> assert false in
    Research (key)
  | `DisplayResearch ->
    let key = match Option.value_exn (List.nth s 0) with Research r -> r | _ -> assert false in
    DisplayResearch (key)
  | `Skip -> Skip
  | `Move ->
    let src = match Option.value_exn (List.nth s 0) with Tile t -> t | _ -> assert false in
    let dst = match Option.value_exn (List.nth s 1) with Tile t -> t | _ -> assert false in
    Move { src; dst }
  | `Attack ->
    let attacker = match Option.value_exn (List.nth s 0) with Tile t -> t | _ -> assert false in
    let target = match Option.value_exn (List.nth s 1) with Tile t -> t | _ -> assert false in
    Attack { attacker; target }
  | `PlaceHub ->
    let role = match Option.value_exn (List.nth s 0) with HubRole r -> r | _ -> assert false in
    let pos = match Option.value_exn (List.nth s 1) with Tile t -> t | _ -> assert false in
    PlaceHub { role; pos }
  | `Clear -> Clear
  | `Produce ->
    let role = match Option.value_exn (List.nth s 0) with EntityRole r -> r | _ -> assert false in
    let hub = match Option.value_exn (List.nth s 1) with Tile t -> t | _ -> assert false in
    Produce { role; hub }
  | `AddEntityToHub ->
    let entity = match Option.value_exn (List.nth s 0) with Tile t -> t | _ -> assert false in
    let hub = match Option.value_exn (List.nth s 1) with Tile t -> t | _ -> assert false in
    AddEntityToHub { entity; hub }
