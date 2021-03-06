open Exception

type entity = Entity.t
type entity_role = Entity.role
type resource = Resource.t
type coord = Coord.t
type art = Art.t

type production =
  | Resource of resource
  | Entity of entity_role

let prod_to_resource = function
  | Resource p -> p
  | _ -> raise (BadInvariant ("hub","prod_to_resource","Expected a resource"))

let is_resource r = match r with
  | Resource _ -> true | _ -> false

type role = {
  (* the name of this role (e.g. "Mill", "Barracks", etc.) *)
  name : string;
  (* a description of this role and its capabilities that would be useful to the
   * player if they wanted to know more about this role *)
  descr : string;
  (* the number of turns after starting production of a hub of this role type
   * that the hub will be available for use *)
  cost_to_make : int;
  (* the ascii art for a hub of this role *)
  art : art;
  (* the types of entities (roles) that are allowed to be consumed by this hub
   * in order to increase its production. E.g. only farmer entities should be
   * able to increase the production of a farm because soldiers and other entity
   * roles don't know how to farm well. *)
  allowed_roles: entity_role list;
  (* the types of things that hubs of this hub role can produce *)
  production: production list;
  (* the production rate of hubs of this hub role when they contain 0 entities *)
  default_production_rate: int;
  (* the default (starting) defense of hubs of this hub role *)
  default_def: int;
}

type t = {
  role: role;
  (* the number of production units this hub generates every turn. This number
   * can be increased by adding entities to the hub *)
  production_rate: int;
  (* the defense of this hub (for when it is attacked by entities)
   * NOTE that the defense is allowed to be negative! It is the responsibility
   * of the caller to check the updated defense value after changing it *)
  def: int;
  (* the position of this hub (in rectangular map coordinates) *)
  pos: coord;
}

let create ~role ~production_rate ~def ~pos = {
  role            = role;
  production_rate = production_rate;
  def             = def;
  pos             = pos;
}

let create_role ~name ~descr ~cost_to_make ~allowed_roles
                ~production ~default_def =
{
  name                    = name;
  descr                   = descr;
  cost_to_make            = cost_to_make;
  art                     = Art.load name;
  allowed_roles           = allowed_roles;
  production              = production;
  default_production_rate = 1;
  default_def             = default_def;
}

let extract_to_role ~name ~descr ~built_by ~default_def ~cost_to_make
                    ~resource ~amount ~entities ~entity_role_list =
    let allowed_roles = [Entity.find_role built_by entity_role_list] in
    let prod_entity =
      let f name = Entity (Entity.find_role name entity_role_list) in
      entities |> List.map f in
    let prod_resource = Resource.str_to_res resource in
    let production = match prod_resource with
      | Some r -> (Resource r)::prod_entity
      | None   -> prod_entity in
    let default_def = amount in
      create_role name descr cost_to_make allowed_roles
      production default_def

let rec find_role role_str role_list =
  if role_str = "all" then role_list else
  match role_list with
  | [] -> raise (Exception.Illegal (role_str^" is not a valid role."))
  | h::t -> if h.name = role_str then [h]
    else find_role role_str t

let describe hub =
  hub.role.name

let describe_role r = "This is a "^r.descr

let tick_cost t =
  {t with role = {t.role with cost_to_make = t.role.cost_to_make - 1}}

let is_done t =
  t.role.cost_to_make = 0

let get_role hub = hub.role

let get_production_rate hub = hub.production_rate

let get_defense hub = hub.def
let change_defense amount hub = { hub with def = hub.def + amount }

let get_position hub = hub.pos
let change_position delta hub =
  let pos' = Coord.add hub.pos delta in
  { hub with pos = pos' }

let change_production_rate delta hub =
  { hub with production_rate = get_production_rate hub + delta }

let get_role_name r = r.name
let get_role_cost_to_make r = r.cost_to_make
let get_role_art r = r.art

let get_role_allowed_roles r = r.allowed_roles
let get_role_production r = r.production
let get_role_default_production_rate r = r.default_production_rate
let get_role_default_defense r = r.default_def

let get_name hub = hub.role.name
let get_cost_to_make hub = hub.role.cost_to_make
let get_art hub = hub.role.art
let get_allowed_roles hub = hub.role.allowed_roles
let get_production hub = hub.role.production
let get_default_production_rate hub = hub.role.default_production_rate
let get_default_defense hub = hub.role.default_def

let rec addto_role_production new_prod_lst hub = match new_prod_lst with
  | [] -> hub
  | prod::lst -> addto_role_production lst { hub with
    role = { (get_role hub) with production =
      prod::(get_role_production (get_role hub))
    }}
