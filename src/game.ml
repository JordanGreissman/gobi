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
  foo : int;
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

let init_state json =
  failwith "Unimplemented"

let load_json s =
  failwith "Unimplemented"

let rec loop ui =
  LTerm_ui.wait ui >>= function
  | LTerm_event.Key { code = Char c } when UChar.char_of c = 'q' -> return ()
  | _ ->
    LTerm_ui.draw ui;
    loop ui

let main () =
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm_ui.create term Interface.draw >>= fun ui ->
  loop ui >>= fun () ->
  LTerm_ui.quit ui

let () = Lwt_main.run (main ())
