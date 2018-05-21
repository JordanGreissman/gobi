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
type unsatisfied_req = [ `Tile | `HubRole | `EntityRole | `ResearchKey ]
type satisfied_req =
  | Tile of Tile.t
  | HubRole of Hub.role
  | EntityRole of Entity.role
  | ResearchKey of Research.Research.key

type pending = cmd * unsatisfied_req list * satisfied_req list

(* [create c] is a unsatisfied requirements list (every constructor is given
 * None) for the command [c]. *)
let create = function
  | `NoCmd           -> (`NoCmd          ,[],[])
  | `NextTurn        -> (`NextTurn       ,[],[])
  | `Tutorial        -> (`Tutorial       ,[],[])
  | `Describe s      -> (`Describe s     ,[],[])
  | `Research        -> (`Research       ,[`ResearchKey],[])
  | `DisplayResearch -> (`DisplayResearch,[`ResearchKey],[])
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
let t_of_pending (c,u,s) =
  (* need to reverse requirements list first because requirements were added
   * like h::t (silly ocaml) *)
  let s = List.rev s in 
  match c with
  | `NoCmd -> Some NoCmd
  | `NextTurn -> Some NextTurn
  | `Tutorial -> Some Tutorial
  | `Describe s -> Some (Describe s)
  | `Research -> begin
      match List.nth s 0 with
      | Some e -> begin
          match e with
          | ResearchKey k -> Some (Research k)
          | _ -> None
        end
      | None -> None
    end
  | `DisplayResearch -> begin
      match List.nth s 0 with
      | Some e -> begin
          match e with
          | ResearchKey k -> Some (DisplayResearch k)
          | _ -> None
        end
      | None -> None
    end
  | `Skip -> Some Skip
  | `Move -> begin
      match (List.nth s 0, List.nth s 1) with
      | (Some e1, Some e2) -> begin
          match (e1, e2) with
          | (Tile src, Tile dst) -> Some (Move {src; dst})
          | _ -> None
        end
      | _ -> None
    end
  | `Attack -> begin
      match (List.nth s 0, List.nth s 1) with
      | (Some e1, Some e2) -> begin
          match (e1, e2) with
          | (Tile attacker, Tile target) -> Some (Attack {attacker; target})
          | _ -> None
        end
      | _ -> None
    end
  | `PlaceHub -> begin
      match (List.nth s 0, List.nth s 1) with
      | (Some e1, Some e2) -> begin
          match (e1, e2) with
          | (HubRole role, Tile pos) -> Some (PlaceHub {role; pos})
          | _ -> None
        end
      | _ -> None
    end
  | `Clear -> Some Clear
  | `Produce -> begin
      match (List.nth s 0, List.nth s 1) with
      | (Some e1, Some e2) -> begin
          match (e1, e2) with
          | (EntityRole role, Tile hub) -> Some (Produce {role; hub})
          | _ -> None
        end
      | _ -> None
    end
  | `AddEntityToHub -> begin
      match (List.nth s 0, List.nth s 1) with
      | (Some e1, Some e2) -> begin
          match (e1, e2) with
          | (Tile entity, Tile hub) -> Some (AddEntityToHub {entity; hub})
          | _ -> None
        end
      | _ -> None
    end
