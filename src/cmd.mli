(** represents the different types of actions that can be bound to keys *)
type cmd =
  (* general commands *)

  (** [NoCmd] represents the absence of a command *)
  | NoCmd
  (** [NextTurn] ends the current turn and proceeds to the next one *)
  | NextTurn
  (** [Tutorial] starts the tutorial *)
  | Tutorial
  (* TODO: do we need separate describe commands for hubs, entities, tiles, etc? *)
  | Describe
  (** [Research r] begins the process of researching [r] *)
  | Research
  (** [DisplayResearch t] displays the research that has already been completed
    * for research tree [t]. *)
  | DisplayResearch

  (* entity commands *)

  (** [Skip t] tells the entity on tile [t] to do nothing and expends all of the
    * entity's remaining movement points *)
  | Skip
  (** [Move (from,to)] moves the entity on tile [from] to tile [to]. [from] and
    * [to] need not be adjacent, but an error message will be displayed if the
    * distance between them is greater than the entity's remaining movement
    * points. *)
  (* NOTE requires second tile to be selected *)
  | Move
  (** [Attack o d] commands the entity on tile [o] to attack the hub or entity on
    * tile [d] *)
  (* NOTE requires second tile to be selected *)
  | Attack

  (* tile commands *)

  (** [PlaceHub (t,r)] places a hub of role [r] on the tile [t] *)
  (* NOTE requires role to be selected from sub-menu *)
  | PlaceHub
  (** [Clear t] clears tile [t] if it is an uncleared Forest tile, and throws an
    * error otherwise. *)
  | Clear

  (* hub commands *)

  (** [Produce (t,r)] produces one entity of role [r] from the hub on tile [t].
    * When an entity is complete, it sits in the town hall until it gets orders.
    *)
  (* NOTE requires role to be selected from sub-menu *)
  | Produce
  (** [AddEntityToHub (e,h)] deletes the entity on tile [e] and increases the
    * production of the hub on tile [h] by 1 if [e] is allowed to be added to
    * [h]. Otherwise, adds an error message to the message list. *)
  (* NOTE requires hub tile to be selected *)
  | AddEntityToHub

  (* dependent commands *)
  (* these commands automatically execute the pending command. If there is no
   * pending command, they throw an error *)

  (** [SelectTile e] gets the tile at the point selected by the mouse and passes
    * this as an argument to the pending command *)
  | SelectTile
  (** [SelectHub h] gets the hub role called [h] and passes this as an argument
    * to the pending command *)
  | SelectHub
  (** [SelectEntity e] gets the entity role called [e] and passes this as an
    * argument to the pending command *)
  | SelectEntity

(** represents the different requirements that commands can have. These
  * requirements need to be fulfilled before the command can be executed. *)
type required =
  | Tile of Tile.t option
  | HubRole of Hub.role option
  | EntityRole of Entity.role option
  | Research of Research.Research.key option

(** a command is a cmd type plus a list of its requirements *)
type t = cmd * required list

(** [create c] is a unsatisfied requirements list (every constructor is given
  * None) for the command [c]. *)
val create : cmd -> t

(** [satisfy_next_req e lst] is [lst] with the first unsatisfied requirement
  * satisfied. If [e] is not of the correct type tojsatisfy such a requirement,
  * raises Illegal. If all requirements are already satisfied, evaluates to [lst]
  *)
(* val satisfy_next_req : LTerm_event.t -> required list -> required list *)

(** [all_all_reqs_satisfied lst] is true if all the requirements in [lst] are
  * satisfied and false otherwise. *)
(* val are_all_reqs_satisfied : required list -> bool *)
