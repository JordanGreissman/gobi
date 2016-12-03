type kind =
  | Info
  | ImportantInfo
  | Illegal
  | Win

type t = {
  text: string;
  kind: kind;
}

let create s k = {
  text = s;
  kind = k;
}

let get_text m = m.text
let get_kind m = m.kind
