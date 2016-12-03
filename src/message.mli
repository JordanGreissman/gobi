(** the type of a message *)
type t

(** the kind of a message. Messages of different kinds are displayed in different
  * colors in the message panel. *)
type kind =
  | Info
  | ImportantInfo
  | Illegal
  | Win

(** [create s k] is a message with text [s] and kind [k] *)
val create : string -> kind -> t

(** [get_text m] is the text of the message [m] *)
val get_text : t -> string

(** [get_kind m] is the kind of message [m] is *)
val get_kind : t -> kind
