type t = Food | Gold | Iron | Paper

(* Returns corresponding variant for lower or uppercase string of same name *)
val str_to_res : string -> t option

(* Combines tuple lists, with the precontion of no repeated resources *)
val add_resources : (t * int) list -> (t * int) list -> (t * int) list

(* val get_name t -> string *)

(* val describe t -> string *)

(* val get_amt civ -> t -> int *)
