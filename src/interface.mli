type draw_context = {
  mutable top_left : Coord.Screen.t;
  (* TODO: it feels wrong to include the map here; I think it should be a part
   * of Game.state *)
  mutable map : Mapp.t;
  mutable selected : Coord.t;
  (* list of messages to be displayed to the user. More recent messages have
   * lower indices, with the most recent message having index 0. *)
  mutable messages : string list;
}

(** draw the entire map at once. This is a turned-based game, so the fact that
  * this operation is expensive shouldn't be a problem *)
val draw : draw_context -> LTerm_ui.t -> LTerm_draw.matrix -> unit
