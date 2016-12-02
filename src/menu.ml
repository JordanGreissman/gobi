open CamomileLibrary

type t = {
  text: string;
  key: LTerm_key.code;
  cmd: Cmd.t;
  next_menu: menu;
}
and menu =
  | NoMenu
  | StaticMenu of t list
  | TileMenu of (Tile.t -> t list)
  | BuildHubMenu of (Hub.role list -> t list)
  | ProduceEntityMenu of (Hub.t -> t list)
  | NextResearchMenu of (Research.Research.key -> t list)

let rec get_tile_menu t =
  let describe = {
    text = "describe";
    key = Char (UChar.of_char 'd');
    cmd = Cmd.create Cmd.Describe;
    next_menu = StaticMenu main_menu;
  } in
  let clear = {
    text = "clear";
    key = Char (UChar.of_char 'c');
    cmd = Cmd.create (Cmd.Clear);
    next_menu = StaticMenu main_menu;
  } in
  let build = {
    text = "build hub";
    key = Char (UChar.of_char 'b');
    cmd = Cmd.create (Cmd.PlaceHub);
    next_menu = BuildHubMenu get_build_hub_menu;
  } in
  let back = {
    text = "back";
    key = Char (UChar.of_char '<');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu main_menu;
  } in
  match (Tile.needs_clearing t,Tile.has_building_restriction t) with
  | (false,false) -> [describe;build;back]
  | (false,true)  -> [describe;back]
  | (true,_)      -> [describe;clear;back]

and get_build_hub_menu roles =
  let describe = {
    text = "describe";
    key = Char (UChar.of_char 'd');
    cmd = Cmd.create Cmd.Describe;
    next_menu = StaticMenu main_menu;
  } in
  [describe]

and get_produce_entity_menu hub =
  let settler = {
    text = "settler";
    key = Char (UChar.of_char 's');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  let worker = {
    text = "worker";
    key = Char (UChar.of_char 'w');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  let warrior = {
    text = "warrior";
    key = Char (UChar.of_char 'r');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  let archer = {
    text = "archer";
    key = Char (UChar.of_char 'a');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  let cavalry = {
    text = "cavalry";
    key = Char (UChar.of_char 'c');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  let heavy = {
    text = "heavy";
    key = Char (UChar.of_char 'h');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  let spearman = {
    text = "spearman";
    key = Char (UChar.of_char 'n');
    cmd = Cmd.create Cmd.Produce;
    next_menu = StaticMenu main_menu;
  } in
  match Hub.describe hub with
  | "town_hall" ->
    [settler;worker]
  | "barracks" ->
    (*eventually check if they have it unlocked*)
    [warrior;archer;cavalry;heavy;spearman]




and get_research_menu r =
  failwith "get_research_menu is unimplemented"

and main_menu = [
  {
    text = "tile";
    key = Char (UChar.of_char 't');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = TileMenu get_tile_menu;
    (* next_menu = NoMenu; *)
  };
  {
    text = "hub";
    key = Char (UChar.of_char 'h');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu hub_menu;
    (* next_menu = NoMenu; *)
  };
  {
    text = "entity";
    key = Char (UChar.of_char 'e');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu entity_menu;
    (* next_menu = NoMenu; *)
  };
  {
    text = "research";
    key = Char (UChar.of_char 'r');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu research_menu;
    (* next_menu = NoMenu; *)
  };
  {
    text = "next turn";
    key = Char (UChar.of_char 'n');
    cmd = Cmd.create Cmd.NextTurn;
    next_menu = NoMenu;
  };
  {
    text = "tutorial";
    key = Char (UChar.of_char '?');
    cmd = Cmd.create Cmd.Tutorial;
    next_menu = NoMenu;
  };
]

and hub_menu = [
  {
    text = "describe";
    key = Char (UChar.of_char 'd');
    cmd = Cmd.create Cmd.Describe;
    next_menu = StaticMenu main_menu;
  };
  {
    text = "produce";
    key = Char (UChar.of_char 'p');
    cmd = Cmd.create Cmd.Produce;
    next_menu = ProduceEntityMenu get_produce_entity_menu;
  };
  {
    text = "add entities";
    key = Char (UChar.of_char 'e');
    cmd = Cmd.create Cmd.AddEntityToHub;
    next_menu = NoMenu;
  };
  {
    text = "back";
    key = Char (UChar.of_char '<');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu main_menu;
  };
]

and entity_menu : t list = [
  {
    text = "describe";
    key = Char (UChar.of_char 'd');
    cmd = Cmd.create Cmd.Describe;
    next_menu = StaticMenu main_menu;
  };
  {
    text = "move";
    key = Char (UChar.of_char 'm');
    cmd = Cmd.create Cmd.Move;
    next_menu = StaticMenu main_menu;
  };
  {
    text = "attack";
    key = Char (UChar.of_char 'a');
    cmd = Cmd.create Cmd.Attack;
    next_menu = StaticMenu main_menu;
  };
  {
    text = "skip";
    key = Char (UChar.of_char 's');
    cmd = Cmd.create Cmd.Skip;
    next_menu = StaticMenu main_menu;
  };
  {
    text = "add to hub";
    key = Char (UChar.of_char 'h');
    cmd = Cmd.create Cmd.AddEntityToHub;
    next_menu = StaticMenu main_menu;
  };
  {
    text = "back";
    key = Char (UChar.of_char '<');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu main_menu;
  };
]

and research_menu : t list = [
  {
    text = "Agriculture";
    key = Char (UChar.of_char '1');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_research_menu;
  };
  {
    text = "Transportation";
    key = Char (UChar.of_char '2');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_research_menu;
  };
  {
    text = "Combat";
    key = Char (UChar.of_char '3');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_research_menu;
  };
  {
    text = "Productivity";
    key = Char (UChar.of_char '4');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_research_menu;
  };
  {
    text = "back";
    key = Char (UChar.of_char '<');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu main_menu;
  };
]

let get_cmd t = t.cmd

let get_next_menu = function
  | Some t -> t.next_menu
  | None -> (StaticMenu main_menu)

(* TODO I don't think this works for any other menu type,
  but we'll have to figure that out *)
(* FIX ME *)
let get_menu menu tile hub_roles hub research_key =
  match menu with
  | NoMenu -> []
  | StaticMenu menu -> menu
  | TileMenu f -> begin match tile with
                  | Tile -> f tile
                  | _ -> failwith "Incorrect arg for menu"
                end
(*   | BuildHubMenu f -> []
  | ProduceEntityMenu f -> []
  | NextResearchMenu f -> [] *)
  | _ -> []
