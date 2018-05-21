open Core_kernel

type win_state = Military | Tech | Score | Tie | No_Win

val dispatch_message: State.t -> string -> Message.kind -> State.t
val init_civ:  bool -> Parser.t -> Mapp.t ref -> 'a -> string * string -> Civ.t
val get_player_start_coords: Civ.t Array.t -> Coord.t * Coord.Screen.t
val init_state: string -> State.t
val add_hubs: Cluster.t list -> Mapp.t -> Hub.t list -> Cluster.t list
val check_for_win: State.t -> State.t
val place_entity_on_map: State.t ref -> Entity.t -> Entity.t
val place_hub_on_map: State.t ref -> Hub.t -> Hub.t
val tick_pending: State.t -> Civ.t -> Civ.t
val next_turn: State.t -> State.t
val execute: State.t -> Cmd.t -> State.t
val satisfy_key_requirement: State.t -> Cmd.pending -> Menu.t -> Cmd.pending
val parse_input_event: State.t -> Cmd.pending -> LTerm_event.t -> State.t * Cmd.pending
val player_loop: LTerm_ui.t -> State.t ref -> Cmd.pending -> unit Lwt.t
val main: unit -> unit Lwt.t
