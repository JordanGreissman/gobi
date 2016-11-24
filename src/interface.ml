(* TODO:
 *   - Draw the hex grid. Make each hex labelled with its coord for debugging purposes
 *   - Enable the map to be panned around with the arrow keys
 *   - Implement selecting a hex with the mouse. The selected hex should be outlined in a new color
 *   - Draw menus and message pane
 *   - Draw dialogs for selecting different things (town hall, other hubs, combat, etc)
 *)

open CamomileLibrary

let ( ^* ) c n = String.make n c

(* [clip art r c0 c1] is the subsection of the tile ascii art [art] at row [r]
 * from characters [c0] to [c1] ([c0] and [c1] are character indices). [c0] is
 * included in the clip, but [c1] is not.
 *)
let clip art r c0 r1 =

let draw ui matrix =
  (* I'm going to hardcode this here for now *)
  let hexagon_side_length = 4 in
  let size = LTerm_ui.size ui in
  let w,h = LTerm.geom.((rows size),(cols size)) in
  let ctx = LTerm_draw.context matrix size in
  let left_pad = hexagon_side_length - 1 in
  (* even edge row *)
  let even_edge_string = (' ' ^* left_pad) ^ 
  (* size_len-2 intermediate rows *)
  (* odd edge row *)
  (* size_len-2 intermediate rows *)
  (* repeat... *)
  LTerm_draw.draw_string ctx 2 2 "Hello, world!";

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
