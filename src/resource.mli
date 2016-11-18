type t 

(* create a resource with a name, default 0 amount *)
val create_resource : string -> t

(* increase / decrese the amount of a particular resource *)
val change_resource_amount : t -> int -> t

