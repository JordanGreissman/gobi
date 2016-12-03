type t = Food | Gold | Iron | Paper

(* Returns corresponding variant for lower or uppercase string of same name *)
val str_to_res : string -> t option

(* Returns tuple of res and amount if found, otherwise raises Illegal *)
val find_res : string -> (t * int) list -> (t * int)

(* changes a specifc resource (String input) by the amount, an int. 
 * Input includes (resource * int) list, returns the same *)
val change_resource : string -> int -> (t * int) list

(* Combines tuple lists, with the precontion of no repeated resources *)
val add_resources : (t * int) list -> (t * int) list -> (t * int) list

(* val get_name t -> string *)

(* val describe t -> string *)

(* val get_amt civ -> t -> int *)
