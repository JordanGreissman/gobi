(** represents a menu item *)
type t

(** [get_menu t] is the list of menu options to be displayed for the tile [t].
  * Menu options are listed in the order they should be displayed (from top to
  * bottom). *)
val get_menu Tile.t -> t list
