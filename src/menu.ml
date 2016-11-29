type t = {
  text: string;
  key: LTerm_key.code;
  action: action;
}


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
