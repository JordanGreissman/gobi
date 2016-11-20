(** the type of a resource *)
type t 

(* val create : name:string -> descr:string -> amt:int -> t *)

(* increase / decrese the amount of a particular resource *)
val change_resource_amount : t -> int -> t

