(** the type of a menu item *)
type t = {
  (** the text of the menu item, displayed next to the key binding *)
  text : string;
  (** the key this menu item is bound to *)
  key : LTerm_key.code;
  (** the action to perform when this menu item is selected *)
  action : Cmd.t;
}

(** [get_menu t] is the list of menu options to be displayed for the tile [t].
  * Menu options are listed in the order they should be displayed (from top to
  * bottom). *)
val get_menu : Tile.t -> t list

val main_menu : t list
val hub_menu : t list
val entity_menu : t list
val research_menu : t list
