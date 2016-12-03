open CamomileLibrary
open Exception

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
  | NextResearchMenu of (Research.Research.research_list -> Research.Research.key -> t list)

let rec get_tile_menu t =
  let describe = {
    text = "describe";
    key = Char (UChar.of_char 'd');
    cmd = Cmd.create (Cmd.Describe "tile");
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
  let hubs = List.mapi (fun i hub -> {
    text = Hub.get_role_name hub;
    key = Char (UChar.of_char (char_of_int i));
    cmd = Cmd.create Cmd.PlaceHub;
    next_menu = NoMenu;
  }) roles in
  let back = {
    text = "back";
    key = Char (UChar.of_char '<');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu main_menu;
  } in
  hubs@[back]

and get_produce_entity_menu hub =
  let settler = {
    text = "settler";
    key = Char (UChar.of_char 's');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  let worker = {
    text = "worker";
    key = Char (UChar.of_char 'w');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  let warrior = {
    text = "warrior";
    key = Char (UChar.of_char 'r');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  let archer = {
    text = "archer";
    key = Char (UChar.of_char 'a');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  let cavalry = {
    text = "cavalry";
    key = Char (UChar.of_char 'c');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  let heavy = {
    text = "heavy";
    key = Char (UChar.of_char 'h');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  let spearman = {
    text = "spearman";
    key = Char (UChar.of_char 'n');
    cmd = Cmd.(create SelectEntity);
    next_menu = StaticMenu main_menu;
  } in
  match Hub.get_role_name (Hub.get_role hub) with
  | "town_hall" -> [settler;worker]
    (* TODO: eventually check if they have it unlocked *)
  | "barracks" -> [warrior;archer;cavalry;heavy;spearman]
  | _ -> raise (Illegal "This hub cannot produce units!")

and get_next_research_menu tech_tree branch_name =
  let describe = {
    text = "describe";
    key = Char (UChar.of_char 'd');
    cmd = Cmd.create (Cmd.Describe "research");
    next_menu = StaticMenu main_menu;
  } in
  match Research.Research.get_next_unlockable branch_name tech_tree with
    | Some u ->
      let next = {
        text = "research " ^ (Research.Unlockable.name u);
        key = Char (UChar.of_char 'r');
        cmd = Cmd.create Cmd.Research;
        next_menu = StaticMenu main_menu;
      } in
      [describe; next]
    | None   -> [describe]

and main_menu = [
  {
    text = "tile";
    key = Char (UChar.of_char 't');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = TileMenu get_tile_menu;
  };
  {
    text = "hub";
    key = Char (UChar.of_char 'h');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu hub_menu;
  };
  {
    text = "entity";
    key = Char (UChar.of_char 'e');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu entity_menu;
  };
  {
    text = "research";
    key = Char (UChar.of_char 'r');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu research_menu;
  };
  {
    text = "next turn";
    key = Char (UChar.of_char 'n');
    cmd = Cmd.create Cmd.NextTurn;
    next_menu = StaticMenu main_menu;
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
    cmd = Cmd.create (Cmd.Describe "hub");
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
    cmd = Cmd.create (Cmd.Describe "entity");
    next_menu = StaticMenu main_menu;
  };
  {
    text = "move";
    key = Char (UChar.of_char 'm');
    cmd = Cmd.create Cmd.Move;
    next_menu = NoMenu;
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
    key = Char (UChar.of_char 'a');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_next_research_menu;
  };
  {
    text = "Transportation";
    key = Char (UChar.of_char 't');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_next_research_menu;
  };
  {
    text = "Combat";
    key = Char (UChar.of_char 'c');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_next_research_menu;
  };
  {
    text = "Productivity";
    key = Char (UChar.of_char 'p');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = NextResearchMenu get_next_research_menu;
  };
  {
    text = "Back";
    key = Char (UChar.of_char '<');
    cmd = Cmd.create Cmd.NoCmd;
    next_menu = StaticMenu main_menu;
  };
]
