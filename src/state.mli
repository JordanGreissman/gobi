(** represents the state of the game *)
type t = {
  (* civs : civ list; *)
  (* turn : int; *)
  (** a list of all the possible kinds of hubs that the player can make and
    * their attributes *)
  hub_roles : Hub.role list;
  (** a list of all the possible kinds of entities that the player can make and
    * their attributes *)
  entity_roles : Entity.role list;
  (** the game map (containing all the tiles in the game) *)
  map : Mapp.t;
  (** what absolute screen coordinate is currently in the top left corner of the
    * player's terminal. This changes as the player moves the map around *)
  screen_top_left : Coord.Screen.t;
  (** the coordinate of the tile that the player currently has selected *)
  selected_tile : Coord.t;
  (** a list of messages (strings) to draw in the message pane. More recent
    * messages first, with the most recent message having index 0 *)
  messages : string list;
  (** whether the player has quit the game *)
  is_quit : bool;
}