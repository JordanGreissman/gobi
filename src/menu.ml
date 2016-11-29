open CamomileLibrary

type t = {
  text: string;
  key: LTerm_key.code;
  (* action: action; *)
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
  | NextTurn             -> state (* TODO *)
  | Describe d           -> state (* TODO *)
  | Settle t             -> state (* TODO *)

let get_tile_menu t =
  let describe = {
    text = "describe";
    key = Char (UChar.of_char 'd');
    (* action = Describe; *)
  } in
  let settle = {
    text = "settle";
    key = Char (UChar.of_char 's');
    (* action = Settle *)
  } in
  let clear = {
    text = "clear";
    key = Char (UChar.of_char 'c');
    (* action = Settle *)
  } in
  let build = {
    text = "build hub";
    key = Char (UChar.of_char 'b');
    (* action = Settle *)
  } in
  let back = {
    text = "back";
    key = Char (UChar.of_char '<');
    (* action = SubMenu *)
  } in
  (* TODO how to implement clearing mechanic? *)
  match (Tile.is_settled t,Tile.is_clear t,Tile.has_building_restriction t) with
  | (true,_,false) -> [describe;build;back]
  | (false,false,_) -> [describe;clear;back]
  | (false,true,true) -> [describe;]

let main_menu : t list = [
  {
    text = "tile";
    key = Char (UChar.of_char 't');
    (* action = SubMenu; *)
  };
  {
    text = "hub";
    key = Char (UChar.of_char 'h');
    (* action = SubMenu; *)
  };
  {
    text = "entity";
    key = Char (UChar.of_char 'e');
    (* action = SubMenu; *)
  };
  {
    text = "research";
    key = Char (UChar.of_char 'r');
    (* action = SubMenu; *)
  };
  {
    text = "next turn";
    key = Char (UChar.of_char 'n');
    (* action = NextTurn; *)
  };
  {
    text = "tutorial";
    key = Char (UChar.of_char '?');
    (* action = Tutorial; *)
  };
]

let hub_menu : t list = [
  {
    text = "describe";
    key = Char (UChar.of_char 'd');
    (* action = Describe *)
  };
  {
    text = "produce";
    key = Char (UChar.of_char 'p');
    (* action = Produce; *)
  };
  {
    text = "add entities";
    key = Char (UChar.of_char 'e');
    (* action = AddEntityToHub; *)
  };
  {
    text = "back";
    key = Char (UChar.of_char '<');
    (* action = SubMenu *)
  };
]

let entity_menu : t list = [
  {
    text = "describe";
    key = Char (UChar.of_char 'd');
    (* action = Describe *)
  };
  {
    text = "move";
    key = Char (UChar.of_char 'm');
    (* action = Produce; *)
  };
  {
    text = "attack";
    key = Char (UChar.of_char 'a');
    (* action = AddEntityToHub; *)
  };
  {
    text = "skip";
    key = Char (UChar.of_char 's');
    (* action = AddEntityToHub; *)
  };
  {
    text = "add to hub";
    key = Char (UChar.of_char 'h');
    (* action = AddEntityToHub; *)
  };
  {
    text = "back";
    key = Char (UChar.of_char '<');
    (* action = SubMenu *)
  };
]

let research_menu : t list = [
  {
    text = "Agriculture";
    key = Char (UChar.of_char '1');
    (* action = Describe *)
  };
  {
    text = "Transportation";
    key = Char (UChar.of_char '2');
    (* action = Produce; *)
  };
  {
    text = "Combat";
    key = Char (UChar.of_char '3');
    (* action = AddEntityToHub; *)
  };
  {
    text = "Productivity";
    key = Char (UChar.of_char '4');
    (* action = AddEntityToHub; *)
  };
  {
    text = "back";
    key = Char (UChar.of_char '<');
    (* action = SubMenu *)
  };
]
