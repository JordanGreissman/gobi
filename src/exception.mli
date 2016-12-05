(** Used for non-critical errors which can be printed to the messages pane, for
  * example, trying to place a hub on a tile that already contains a hub. Usually
  * these errors are illegal actions within the game. The sole argument is the
  * error message to be displayed in the messages pane. *)
exception Illegal of string

(** Used for critical errors which halt program execution, such as failure to
  * parse game json. Arguments are filename, function name, and error string *)
exception Critical of string * string * string

(** Used for invariant violations which halt program execution because they are
  * indicative of a major bug in the program. Arguments are filename, function
  * name, and error string *)
exception BadInvariant of string * string * string
