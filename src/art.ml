type cell = {
  char : char;
  color : int;
}

type t = cell list

let load name =
  failwith "Unimplemented"
  (* read file with art *)
  (* TODO what exception to throw if file read unsuccessful? *)
