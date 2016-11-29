(** represents the different types of actions that can be bound to keys *)
type t =
  (** [SubMenu m] displays the menu [m] *)
  | SubMenu of t list
  (** [Research r] begins the process of researching [r] *)
  | Research of Research.Research.key
  (** [DisplayResearch t] displays the research that has already been completed
    * for research tree [t]. *)
  | DisplayResearch of Research.Research.key
  (** [Skip t] tells the entity on tile [t] to do nothing and expends all of the
    * entity's remaining movement points *)
  | Skip
  (** [Move (from,to)] moves the entity on tile [from] to tile [to]. [from] and
    * [to] need not be adjacent, but an error message will be displayed if the
    * distance between them is greater than the entity's remaining movement
    * points. *)
  (* NOTE requires second tile to be selected *)
  | Move of Tile.t*Tile.t
  (** [Attack o d] commands the entity on tile [o] to attack the hub or entity on
    * tile [d] *)
  (* NOTE requires second tile to be selected *)
  | Attack of Tile.t*Tile.t
  (** [PlaceHub (t,r)] places a hub of role [r] on the tile [t] *)
  (* NOTE requires role to be selected from sub-menu *)
  | PlaceHub of Tile.t*Hub.role
  (** [Produce (t,r)] produces one entity of role [r] from the hub on tile [t].
    * When an entity is complete, it sits in the town hall until it gets orders.
    *)
  (* NOTE requires role to be selected from sub-menu *)
  | Produce of Tile.t*Entity.role
  (** [AddEntityToHub (e,h)] deletes the entity on tile [e] and increases the
    * production of the hub on tile [h] by 1 if [e] is allowed to be added to
    * [h]. Otherwise, adds an error message to the message list. *)
  (* NOTE requires hub tile to be selected *)
  | AddEntityToHub of Tile.t*Tile.t

(** [execute s a] returns the next state of the game given the current state [s]
  * and the action [a]. *)
val execute : State.t -> action -> State.t
