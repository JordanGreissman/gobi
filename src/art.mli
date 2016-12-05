
type cell
type t = cell option list list

(** Returns the data needed to create ASCII art, where name
  * is a valid art file stored in the game. *)
val load : string -> t

(** Returns the char associated with a valid cell *)
val get_char : cell -> char

(** Returns the color of a valid cell *)
val get_color : cell -> LTerm_style.color
