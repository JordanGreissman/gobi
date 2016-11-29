open LTerm_style

type cell = {
  char : char;
  color : color;
}

type t = cell option list list

let load name =
  (* open and read the art file *)
  let lines = ref [] in
  let chan = open_in ("art/"^name) in
  (try
    while true; do
      lines := input_line chan :: !lines
    done
  with End_of_file -> close_in chan);
  let lines = List.rev !lines in
  (* parse the raw text into a [t] *)
  let line_pairs =
    let f i = (List.nth lines i,List.nth lines (i+6)) in
    [0;1;2;3;4] |> List.map f in
  let f (chars,colors) =
    let explode s =
      let rec exp i l =
        if i < 0 then l else exp (i - 1) (s.[i] :: l) in
      exp (String.length s - 1) [] in
    let chars = String.trim chars in
    let colors = String.trim colors in
    let combined =
      try List.combine (explode chars) (explode colors)
      with Invalid_argument _ -> failwith "Malformatted ascii art file" in
    combined |> List.map (fun (ch,cl) ->
        if ch = 'N' then None else Some {char=ch;color=match cl with
        | 'K' -> black
        | 'R' -> red
        | 'G' -> green
        | 'Y' -> yellow
        | 'B' -> blue
        | 'M' -> magenta
        | 'C' -> cyan
        | 'W' -> white
        | 'k' -> lblack
        | 'r' -> lred
        | 'g' -> lgreen
        | 'y' -> lyellow
        | 'b' -> lblue
        | 'm' -> lmagenta
        | 'c' -> lcyan
        | 'w' -> lwhite
        (* feel free to set this rgb value to something distinctive
         * for debugging purposes *)
        | _ -> rgb 0 0 0
      }) in
  line_pairs |> List.map f
                                 
let get_char cell = cell.char
let get_color cell = cell.color
