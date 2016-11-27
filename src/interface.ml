(* TODO:
 *   - [x] Draw the hex grid. Make each hex labelled with its coord for debugging purposes
 *   - [x] Enable the map to be panned around with the arrow keys
 *   - [x] Implement selecting a hex with the mouse. The selected hex should be outlined in a new color
 *   - [ ] Draw menus and message pane
 *   - [ ] Draw dialogs for selecting different things (town hall, other hubs, combat, etc)
 *)

open CamomileLibrary

type draw_context = {
  mutable top_left : Coord.Screen.t;
  mutable map : Mapp.t;
  mutable selected : Coord.t;
  mutable messages : string list;
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

let draw_map ctx top_left map w h selected =
  let edge_style = {
    LTerm_style.none with foreground = (Some LTerm_style.red)
  } in
  let selected_edge_style = {
    LTerm_style.none with
    foreground = (Some LTerm_style.yellow);
    background = (Some LTerm_style.yellow);
  } in
  let none_style = {
    LTerm_style.none with
    foreground = (Some LTerm_style.black);
    background = (Some LTerm_style.black);
  } in
  LTerm_draw.clear ctx;
  for y = 0 to h do
    for x = 0 to w do
      (* the cell we're currently drawing in absolute lambda-term coords *)
      let delta = Coord.Screen.create x y in
      let screen_cur = Coord.Screen.add top_left delta in
      (* the hex or hexes containing that cell *)
      match Coord.offset_from_screen screen_cur with
      (* we're inside a hex *)
      | Contained c ->
        let t = Mapp.tile_by_pos c map in
        let cell = Tile.get_art_char screen_cur t in
        print_endline "here";
        let style = match cell with
          | Some c ->
            { LTerm_style.none with foreground = Some (Art.get_color c) }
          | None -> none_style in
        let ch = match cell with
          | Some c -> Art.get_char c
          | None   -> 'x' in
        LTerm_draw.draw_char ctx y x ~style (UChar.of_char ch);
        (* LTerm_draw.draw_char ctx y x (UChar.of_char '~') *)
      (* we're on the border between two hexes *)
      | Border (h1,h2,h3) ->
        let is_selected =
          (h1 = selected) ||
          (match h2 with Some c when c = selected -> true | _ -> false) ||
          (match h3 with Some c when c = selected -> true | _ -> false) in
        let style = if is_selected then selected_edge_style else edge_style in
        LTerm_draw.draw_char ctx y x ~style (UChar.of_char '.')
      (* we're off the edge of the map *)
      | None ->
        LTerm_draw.draw_char ctx y x ~style:none_style (UChar.of_char 'x')
    done
  done

let draw_messages ctx w h messages =
  LTerm_draw.clear ctx;
  (* draw an ascii box because the built-in boxes don't work on OSX *)
  for i = 1 to (w-1) do
    LTerm_draw.draw_char ctx 0     i (UChar.of_char '-');
    LTerm_draw.draw_char ctx (h-1) i (UChar.of_char '-')
  done;
  for i = 1 to (h-1) do
    LTerm_draw.draw_char ctx i 0     (UChar.of_char '|');
    LTerm_draw.draw_char ctx i (w-1) (UChar.of_char '|')
  done;
  LTerm_draw.draw_char ctx 0     0     (UChar.of_char '+');
  LTerm_draw.draw_char ctx (h-1) 0     (UChar.of_char '+');
  LTerm_draw.draw_char ctx 0     (w-1) (UChar.of_char '+');
  LTerm_draw.draw_char ctx (h-1) (w-1) (UChar.of_char '+');
  (* draw the messages *)
  for i = 1 to min (h-2) (List.length messages) do
    LTerm_draw.draw_string ctx i 1 (List.nth messages (i-1))
  done

(* NOTE lambda-term coordinates are given y first, then x *)
let draw dctx ui matrix =
  let message_box_height = 10 in
  let size = LTerm_ui.size ui in
  let w,h = LTerm_geom.((cols size),(rows size)) in
  let ctx = LTerm_draw.context matrix size in
  let map_ctx = LTerm_draw.sub ctx {row1=0;row2=(h-message_box_height);col1=0;col2=w} in
  let message_ctx = LTerm_draw.sub ctx {row1=(h-message_box_height);row2=h;col1=0;col2=w} in
  draw_map map_ctx dctx.top_left dctx.map w (h-message_box_height) dctx.selected;
  draw_messages message_ctx w message_box_height dctx.messages
