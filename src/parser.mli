type t = {
  turns: int;
  ai: int;
  entities: Entity.role list;
  hubs: Hub.role list;
  civs: (string * string) list;
  tech_tree: Research.Research.research_list;
}

(** Given a filename, returns parsed json structure *)
val init_json : string -> t
