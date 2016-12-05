open CamomileLibrary
open Exception

type state = State.t

let draw_map ctx w h x_offset (s:State.t) =
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
      let screen_cur = Coord.Screen.add s.screen_top_left delta in
      (* the hex or hexes containing that cell *)
      match Coord.offset_from_screen screen_cur with
      (* we're inside a hex *)
      | Contained c ->
        let t = Mapp.tile_by_pos c s.map in
        let cell = Tile.get_art_char screen_cur t in
        let style = match cell with
          | Some c ->
            { LTerm_style.none with foreground = Some (Art.get_color c) }
          | None -> none_style in
        let ch = match cell with
          | Some c -> Art.get_char c
          | None   -> 'x' in
        LTerm_draw.draw_char ctx y x ~style (UChar.of_char ch)
        (* LTerm_draw.draw_char ctx y x (UChar.of_char '~') *)
      (* we're on the border between two hexes *)
      | Border (h1,h2,h3) ->
        let selected = s.selected_tile in
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

let draw_tutorial ctx w h =
  let tutorial = [
    "Gooby is a turn-based strategy game based on Sid Meier's Civilization V.";
    "Your task is to build a civilization that will stand the test of time. Grow";
    "your citiies, build your armies, and destroy the other civilizations to win";
    "the game!";
    "";
    "Resources fuel your growing civilization. They enable you to conduct research,";
    "build hubs, produce entities, and allow your civilization to grow. There are";
    "four resources in Gooby: food, gold, iron, and paper. They are produced from";
    "different hubs and each one is required for a variety of purposes. Discovering";
    "which hubs produce which resources and which resources are required for various";
    "purposes is part of the learning curve of the game and will be left up to you.";
    "";
    "Entities in Gooby are mobile units. Their primary uses are constructing new";
    "hubs, attacking and defending, and increasing the production of hubs. There";
    "are several types of entities in the game (hereafter called 'roles'). Giving";
    "and order to an entity constitutes an 'action'. Each role has a different";
    "number of allowed actions per turn, after which they will not be able to do";
    "more until the next turn. Each role has different strengths, weaknesses, and";
    "abilities. Discovering these is also part of the fun of learning the game.";
    "";
    "Hubs are buildings which produce resources and entities. Each hub has a ";
    "different cost to build and produces different things. The rate at which a";
    "hub produces things can be increased by dedicating entities to 'working' in";
    "that hub. When this happens, the entity is consumed by the hub (you cannot";
    "get it back later) and the production rate of the hub is permanently increased.";
    "";
    "There are three ways to win the game:";
    "    1) Complete an entire research branch";
    "    2) Destroy every competing civilization";
    "    3) Have the largest standing civilization when the turn limit is reached";
    "";
    "Use the arrow keys to pan around the map and the mouse to select tiles. The";
    "menu on the left-hand side of the screen enables you to give commands to the";
    "game. Keybindings are given in blue.";
    "";
    "Press ESC (escape) to exit this tutorial. Good luck!";
  ] in
  let y = ref 1 in
  LTerm_draw.clear ctx;
  LTerm_draw.draw_string ctx 0 ((w-24)/2) "Welcome to Gooby!";
  List.iter
    (fun s ->
       LTerm_draw.draw_string ctx !y 0 s;
       incr y)
    tutorial

let draw_ascii_frame ctx w h =
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
  LTerm_draw.draw_char ctx (h-1) (w-1) (UChar.of_char '+')

let draw_messages ctx w h messages =
  LTerm_draw.clear ctx;
  (* draw an ascii box because the built-in boxes don't work on OSX *)
  draw_ascii_frame ctx w h;
  (* draw the messages *)
  for i = 1 to min (h-2) (List.length messages) do
    let m = (List.nth messages (i-1)) in
    let style = match Message.get_kind m with
      | Message.Info -> LTerm_style.none
      | Message.ImportantInfo ->
        { LTerm_style.none with foreground = Some (LTerm_style.blue) }
      | Message.Illegal ->
        { LTerm_style.none with foreground = Some (LTerm_style.red) }
      | Message.Win ->
        { LTerm_style.none with foreground = Some (LTerm_style.yellow) } in
    LTerm_draw.draw_string ctx i 1 ~style:style (Message.get_text m)
  done

let draw_resources ctx w h resources =
  let key_style = { LTerm_style.none with foreground = Some (LTerm_style.blue) } in
  LTerm_draw.draw_string ctx 3 1 "Resources:";
  for y = 0 to 3 do
    let (resource, amount) = List.nth resources y in
    LTerm_draw.draw_string ctx (y + 5) 2 (
      if y = 3 then
        (Resource.res_to_str resource)^": "^(string_of_int amount)
      else
        (Resource.res_to_str resource)^":  "^(string_of_int amount));
  done

let draw_menu ctx w h menu turn =
  (* chops the text of each menu item up into as many pieces are necessary to
   * fit inside the text_width of the menu. Returns a string list, where
   * each string is padded to the full width of the menu. The first string in
   * each list is padded with the string "| [ ] " in preparation for drawing
   * a key binding (this is done as a separate step).
   *)
  let text_width = w - (String.length "| [k] |") in
  let chop s =
    let rec f s lst =
      let pad = if lst = [] then " [ ] " else "     " in
      if (String.length s) > text_width then
        let s1 = String.sub s 0 text_width in
        (* print_endline s1; *)
        let s2 = String.sub s (text_width) ((String.length s) - text_width) in
        (* print_endline s2; *)
        f s2 ((pad^s1)::lst)
      else (pad^s)::lst in
    List.rev (f s []) in
  (* given a list of heights of menu items, returns a list of y coordinates
   * where each menu item should be drawn *)
  let get_y heights =
    let rec f y ys = function
      | []   -> ys
      | h::t ->
        let y' = y+h in
        f y' (y::ys) t in
    heights |> f 1 [] |> List.rev in
  (* chop up each menu item *)
  let chopped_menu = List.map (fun (m:Menu.t) -> chop m.text) menu in
  (* get the chopped heights (# of lines) of each chopped menu item *)
  let lengths = List.map List.length chopped_menu in
  (* find the y-coord at which each one starts based on the heights *)
  let ys = get_y lengths in
  let ym = List.combine ys chopped_menu in
  (* draw boring stuff *)
  LTerm_draw.clear ctx;
  draw_ascii_frame ctx w h;
  LTerm_draw.draw_string ctx 1 1 ("Turn: "^(string_of_int turn));
  (* draw the strings without key bindings *)
  List.iter (fun (y,strs) ->
      List.iteri (fun i s ->
          LTerm_draw.draw_string ctx (y+i+1) 1 s) strs) ym;
  (* draw the key bindings as a separate step *)
  let key_style = { LTerm_style.none with foreground = Some (LTerm_style.blue) } in
  let keys = List.map (fun (m:Menu.t) -> m.key) menu in
  List.combine ys keys |> List.iter (fun (y,k) -> match k with
    | LTerm_key.Char c ->
      LTerm_draw.draw_char ctx (y+1) 3 ~style:key_style c;
    | e -> raise (Critical (
        "interface",
        "draw_menu",
        "Unexpected key input: " ^
        (LTerm_key.to_string {control=false;meta=false;shift=false;code=e}))))


(* NOTE lambda-term coordinates are given y first, then x *)
let draw (s:State.t ref) ui matrix =
  let message_box_height = 10 in
  let menu_width = 20 in
  let size = LTerm_ui.size ui in
  let w,h = LTerm_geom.((cols size),(rows size)) in
  let ctx = LTerm_draw.context matrix size in
  let map_ctx = LTerm_draw.sub ctx {row1=0;row2=(h-message_box_height);col1=menu_width;col2=w} in
  let message_ctx = LTerm_draw.sub ctx {row1=(h-message_box_height);row2=h;col1=0;col2=w} in
  let menu_ctx = LTerm_draw.sub ctx {row1=0;row2=(h-message_box_height);col1=0;col2=menu_width} in
  if !s.is_tutorial
  then draw_tutorial map_ctx (w-menu_width) (h-message_box_height)
  else draw_map map_ctx (w-menu_width) (h-message_box_height) menu_width !s;
  draw_messages message_ctx w message_box_height !s.messages;
  draw_menu menu_ctx menu_width (h-message_box_height) !s.menu !s.turn
