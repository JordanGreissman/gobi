let draw ui matrix =
  let size = LTerm_ui.size ui in
  let ctx = LTerm_draw.context matrix size in
  LTerm_draw.draw_string ctx 2 2 "Hello, world!"

(* let print_hexagon color side_length fill_char = *)
(*   let rec go l f = *)
(*     let indent = String.make l ' ' in *)
(*     let fill = String.make f fill_char in *)
(*     ANSITerminal.(printf [color] "%s." indent); *)
(*     ANSITerminal.(printf [white] "%s" fill); *)
(*     ANSITerminal.(printf [color] ".\n"); *)

(*     if indent = "" then () else ( *)
(*     go (l-1) (f+2); *)
(*     ANSITerminal.(printf [color] "%s." indent); *)
(*     ANSITerminal.(printf [white] "%s" fill); *)
(*     ANSITerminal.(printf [color] ".\n")) in *)
(*   let indent = String.make (side_length-1) ' ' in *)
(*   let side = ref "" in *)
(*   for i = 1 to side_length do side := !side ^ ". " done; *)
(*   ANSITerminal.(printf [color] "%s%s\n" indent !side); *)
(*   go (side_length-2) (side_length*2); *)
(*   ANSITerminal.(printf [color] "%s%s\n" indent !side) *)

(* let () = print_hexagon red 4 '~' *)
