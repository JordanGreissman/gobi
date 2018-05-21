(** represents the different types of actions that can be bound to keys *)
type t =
  (* general commands *)

  (** [NoCmd] represents the absence of a command *)
  | NoCmd
  (** [NextTurn] ends the current turn and proceeds to the next one *)
  | NextTurn
  (** [Tutorial] starts the tutorial *)
  | Tutorial
  (** [Describe str] describes the currently selected [str], if there is one *)
  | Describe of string
  (** [Research r] begins the process of researching [r] *)
  | Research of Research.Research.key
  (** [DisplayResearch t] displays the research that has already been completed
    * for research tree [t]. *)
  | DisplayResearch of Research.Research.key

  (* entity commands *)

  (** [Skip] tells the entity on the currently selected tile to do nothing and expends all of the
    * entity's remaining movement points *)
  | Skip
  (** [Move (from,to)] moves the entity on tile [from] to tile [to]. [from] and
    * [to] need not be adjacent, but an error message will be displayed if the
    * distance between them is greater than the entity's remaining movement
    * points. *)
  (* NOTE requires second tile to be selected *)
  | Move of { src: Tile.t; dst: Tile.t }
  (** [Attack o d] commands the entity on tile [o] to attack the hub or entity on
    * tile [d] *)
  (* NOTE requires second tile to be selected *)
  | Attack of { attacker: Tile.t; target: Tile.t }

  (* tile commands *)

  (** [PlaceHub (t,r)] places a hub of role [r] on the tile [t] *)
  (* NOTE requires role to be selected from sub-menu *)
  | PlaceHub of { role: Hub.role; pos: Tile.t }
  (** [Clear] clears the currently selected tile if it is an uncleared Forest tile, and throws an
    * error otherwise. *)
  | Clear

  (* hub commands *)

  (** [Produce (t,r)] produces one entity of role [r] from the hub on tile [t].
    * When an entity is complete, it sits in the town hall until it gets orders.
    *)
  (* NOTE requires role to be selected from sub-menu *)
  | Produce of { role: Entity.role; hub: Tile.t }
  (** [AddEntityToHub (e,h)] deletes the entity on tile [e] and increases the
    * production of the hub on tile [h] by 1 if [e] is allowed to be added to
    * [h]. Otherwise, adds an error message to the message list. *)
  (* NOTE requires hub tile to be selected *)
  | AddEntityToHub of { entity: Tile.t; hub: Tile.t }

  (* dependent commands *)
  (* these commands automatically execute the pending command. If there is no
   * pending command, they throw an error *)

  (* (\** [SelectTile e] gets the tile at the point selected by the mouse and passes *)
  (*   * this as an argument to the pending command *\) *)
  (* | SelectTile *)
  (* (\** [SelectHub h] gets the hub role called [h] and passes this as an argument *)
  (*   * to the pending command *\) *)
  (* | SelectHub *)
  (* (\** [SelectEntity e] gets the entity role called [e] and passes this as an *)
  (*   * argument to the pending command *\) *)
  (* | SelectEntity *)

type cmd = [ `NoCmd | `NextTurn | `Tutorial | `Describe of string | `Research |
             `DisplayResearch | `Skip | `Move | `Attack | `PlaceHub | `Clear |
             `Produce | `AddEntityToHub ]
type unsatisfied_req = [ `Tile | `HubRole | `EntityRole | `Research ]
type satisfied_req =
  | Tile of Tile.t
  | HubRole of Hub.role
  | EntityRole of Entity.role
  | Research of Research.Research.key

type pending = cmd * unsatisfied_req list * satisfied_req list

val create : cmd -> pending

val t_of_pending : pending -> t
