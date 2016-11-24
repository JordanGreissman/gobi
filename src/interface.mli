(** draw the entire map at once. This is a turned-based game, so the fact that
  * this operation is expensive shouldn't be a problem *)
val draw : Mapp.t -> Coord.lt_coordinate -> LTerm_ui.t -> LTerm_draw.matrix -> unit
