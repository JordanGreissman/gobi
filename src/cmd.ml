type t =
  | SubMenu of t list
  | Research of Research.Research.key
  | DisplayResearch of Research.Research.key
  | Skip
  | Move of Tile.t*Tile.t
  | Attack of Tile.t*Tile.t
  | PlaceHub of Tile.t*Hub.role
  | Produce of Tile.t*Entity.role
  | AddEntityToHub of Tile.t*Tile.t
