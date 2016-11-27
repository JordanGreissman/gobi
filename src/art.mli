type cell
type t = cell option list list

val load : string -> t
val get_char : cell -> char
val get_color : cell -> LTerm_style.color
