(** the type of a menu item *)
type t = {
  (** the text of the menu item, displayed next to the key binding *)
  text : string;
  (** the key this menu item is bound to *)
  key : LTerm_key.code;
  (** the cmd to execute when this menu item is selected. A value of [None]
    * indicates that this menu item does not execute a command. *)
  cmd: Cmd.t;
  (** the menu to display next after executing this command. A value of [None]
    * indicates to keep displaying the same menu. *)
  next_menu: menu;
}
(** represents the different types of menus that exist in the game and how to
  * access them. Many menu types depend on contextual information from the
  * game state, so their types are functions *)
and menu =
  | NoMenu
  | StaticMenu of t list
  | TileMenu of (Tile.t -> t list)
  | BuildHubMenu of (Hub.role list -> t list)
  | ProduceEntityMenu of (Hub.t -> t list)
  | NextResearchMenu of (Research.Research.key -> t list)

(** [get_menu t] is the list of menu options to be displayed for the tile [t].
  * Menu options are listed in the order they should be displayed (from top to
  * bottom). *)
(* val get_menu : Tile.t -> t list *)

val get_tile_menu : Tile.t -> t list
val get_build_hub_menu : Hub.role list -> t list
val get_produce_entity_menu : Hub.t -> t list
val get_research_menu : Research.Research.key -> t list

val main_menu : t list
val hub_menu : t list
val entity_menu : t list
val research_menu : t list

val get_cmd : t -> Cmd.t
val get_next_menu : t option-> menu

val get_menu : menu -> Tile.t option -> Hub.role list ->
              Hub.t option -> Research.Research.key option -> t list