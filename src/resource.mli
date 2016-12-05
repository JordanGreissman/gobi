type t = Food | Gold | Iron | Paper

(** Convert resource to descriptive string, empty string otherwise *)
val res_to_str : t -> string

(** Returns corresponding variant for lower or uppercase string of same name *)
val str_to_res : string -> t option

(** Returns tuple of resource and amount if in list of resources 
  * and amounts otherwise raises Illegal *)
val find_res : string -> (t * int) list -> (t * int)

(** Changes a specifc resource, a string, by the amount, an int. 
  * Input includes (resource * int) list, returns the same *)
val change_resource : string -> int -> (t * int) list -> (t * int) list

(** Combines tuple lists, with the precontion of no repeated resources *)
val add_resources : (t * int) list -> (t * int) list -> (t * int) list

