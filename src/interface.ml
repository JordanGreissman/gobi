(* TODO:
 *   - Draw the hex grid. Make each hex labelled with its coord for debugging purposes
 *   - Enable the map to be panned around with the arrow keys
 *   - Implement selecting a hex with the mouse. The selected hex should be outlined in a new color
 *   - Draw menus and message pane
 *   - Draw dialogs for selecting different things (town hall, other hubs, combat, etc)
 *)

open CamomileLibrary

type draw_context = {
  mutable top_left : Coord.Screen.t;
  mutable map : Mapp.t;
}

let ( ^* ) c n = String.make n c

(* [clip art r c0 c1] is the subsection of the tile ascii art [art] at row [r]
 * from characters [c0] to [c1] ([c0] and [c1] are character indices). [c0] is
 * included in the clip, but [c1] is not.
 *)
let clip art r c0 c1 =
  let row = try List.nth r art with
    (* TODO: replace this failwith with an out_of_bounds exception *)
    | Failure _ | Invalid_argument _ -> failwith "Out of bounds"
    | _ -> failwith "Unknown error" in
  try String.sub row c0 (c1-c0) with
    | Invalid_argument _ -> failwith "Out of bounds"
    | _ -> failwith "Unknown error"

(* even edge row *)
(* size_len-2 intermediate rows *)
(* odd edge row *)
(* size_len-2 intermediate rows *)
(* repeat... *)
let draw dctx ui matrix =
  (* I'm going to hardcode this here for now *)
  let hexagon_side_length = 4 in
  let size = LTerm_ui.size ui in
  let w,h = LTerm_geom.((rows size),(cols size)) in
  let ctx = LTerm_draw.context matrix size in
  let edge_style = { LTerm_style.none with foreground = (Some LTerm_style.red) } in
  for y = 0 to h do
    for x = 0 to w do
      (* the cell we're currently drawing in absolute lambda-term coords *)
      let delta = Coord.Screen.create x y in
      let screen_cur = Coord.Screen.add dctx.top_left delta in
      (* the hex or hexes containing that cell *)
      match Coord.offset_from_screen screen_cur with
      (* we're inside a hex *)
      | Some c ->
        (* let t = Mapp.tile_by_pos c dctx.map in *)
        (* let c = Tile.get_art_char t screen_cur in *)
        (* LTerm_draw.draw_char ctx x y (UChar.of_char c); *)
        LTerm_draw.draw_char ctx x y (UChar.of_char '~')
      (* we're on the border between two hexes *)
      | None -> LTerm_draw.draw_char ctx x y ~style:edge_style (UChar.of_char '.');
    done
  done

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
