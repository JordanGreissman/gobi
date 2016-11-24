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
  mutable top_left : Coord.lt_coordinate;
  mutable map : Mapp.t;
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
  top_left = (Coord.make_lt_coordinate 0 0);
  (* TODO: what are the width and height params to generate? *)
  map = Mapp.generate 0 0;
}

let load_json s = 
  failwith "Unimplemented"

let rec loop ui state =
  LTerm_ui.wait ui >>= function
  | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' -> return ()
  | _ ->
    LTerm_ui.draw ui;
    loop ui state

let main () =
  let state = init_state () in
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm_ui.create term (Interface.draw state.map state.top_left) >>= fun ui ->
  loop ui state >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
