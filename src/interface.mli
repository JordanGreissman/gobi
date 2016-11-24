(** draw the entire map at once. This is a turned-based game, so the fact that
  * this operation is expensive shouldn't be a problem *)
val draw : LTerm_ui.t -> LTerm_draw.matrix -> unit
