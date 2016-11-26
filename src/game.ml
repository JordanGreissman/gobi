(* open Cluster *)
(* open Combat *)
(* open Ai *)
(* open Tile *)
open Mapp
(* open Interface *)
(* open Research *)
open Yojson
open Lwt
open CamomileLibrary

type state = {
  mutable ctx : Interface.draw_context;
}

type cmd = {
  verb : string;
  obj : string;
}

let make_move st cmd =
  failwith "Unimplemented"

let parse_input s =
  failwith "Unimplemented"

let turn st =
  failwith "Unimplemented"

let init_state json = {
  (* TODO: what are the width and height params to generate? *)
  ctx = {
    top_left = Coord.Screen.create 0 0;
    map = Mapp.generate 0 0;
    (* selected = Coord.origin; *)
    selected = Coord.create 1 1;
    messages = [ "This is a test message" ];
  };
}

let load_json s = 
  failwith "Unimplemented"

let rec loop ui state =
  LTerm_ui.wait ui >>= function
  | LTerm_event.Mouse e ->
    (* let new_msg' = Printf.sprintf "Mouse clicked at (%d,%d)" e.col e.row in *)
    (* state.ctx.messages <- new_msg'::state.ctx.messages; *)
    let abs_click_coord = Coord.Screen.add state.ctx.top_left (Coord.Screen.create e.col e.row) in
    (match Coord.offset_from_screen abs_click_coord with
    | Contained c ->
      state.ctx.selected <- c;
      let new_msg = Printf.sprintf "Selected tile is now %s" (Coord.to_string c) in
      state.ctx.messages <- new_msg::state.ctx.messages
    | _ -> ());
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Up } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create 0 (-1));
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Down } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create 0 1);
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Left } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create (-2) 0);
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = LTerm_key.Right } ->
    state.ctx.top_left <- Coord.Screen.add state.ctx.top_left (Coord.Screen.create 2 0);
    LTerm_ui.draw ui;
    loop ui state
  | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' -> return ()
  | _ ->
    LTerm_ui.draw ui;
    loop ui state

let main () =
  let state = init_state () in
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  LTerm_ui.create term (Interface.draw state.ctx) >>= fun ui ->
  loop ui state >>= fun () ->
  LTerm.disable_mouse term >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
