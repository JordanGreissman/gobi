type t = {
  (* the text of the menu item, displayed next to the key binding *)
  text : string;
  (* the key this menu item is bound to *)
  key : CamomileLibrary.UChar.t;
  action : ;
}

and action =
  (* [SubMenu m] displays the menu [m] *)
  | SubMenu of t list

  | MoveEntity (Tile.t,Coo)
  (* [Attack o d] commands the entity on tile [o] to attack the hub or entity on
   * tile [d] *)
  | Attack of (Tile.t,Tile.t)
  | Skip

  (* [PlaceHub (t,r)] places a hub of role [r] on the tile [t] *)
  | PlaceHub of (Tile.t,Hub.role)
  (* [Produce (t,r)] produces one entity of role [r] from the hub on tile [t] *)
  | Produce of (Tile.t,Entity.role)
  (* [AddEntityToHub (e,h)] deletes the entity on tile *)
  | AddEntityToHub of (Tile.t,Tile.t)
  | Research
