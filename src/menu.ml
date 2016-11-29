type t = {
  text: string;
  key: LTerm_key.code;
  action: action;
}

and action =
  | SubMenu of t list
  | Research of Research.Research.key
  | DisplayResearch of Research.Research.key
  | Skip
  | Move of Tile.t*Tile.t
  | Attack of Tile.t*Tile.t
  | PlaceHub of Tile.t*Hub.role
  | Produce of Tile.t*Entity.role
  | AddEntityToHub of Tile.t*Tile.t

let get_menu t =
  failwith "Menu.get_menu is unimplemented"

(* [execute s a] returns the next state of the game given the current state [s]
 * and the action [a]. *)
let execute state = function
  | SubMenu m            -> state (* TODO *)
  | Research r           -> state (* TODO *)
  | DisplayResearch t    -> state (* TODO *)
  | Skip                 -> state (* TODO *)
  | Move (from,to)       -> state (* TODO *)
  | Attack (o,d)         -> state (* TODO *)
  | PlaceHub (t,r)       -> state (* TODO *)
  | Produce (t,r)        -> state (* TODO *)
  | AddEntityToHub (e,h) -> state (* TODO *)
