(** Draw the entire map at once. This is a turned-based game, so the fact that
  * this operation is expensive shouldn't be a problem *)
val draw : State.t ref -> LTerm_ui.t -> LTerm_draw.matrix -> unit
