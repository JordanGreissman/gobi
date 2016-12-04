(* type t = { *)
(* 	name: string; *)
(* 	amount: int; *)
(* } *)

(* create a resource with a name, default 0 amount *)
(* let create_resource name =  *)
(* 	{ name = name; amount = 0 } *)

(* increase / decrease the amount of a particular resource
 * use positive int to increase, negative int to decrease *)
(* let change_resource_amount resource amount_change = *)
(*   let amt = resource.amount in *)
(*   { resource with amount = amt + amount_change } *)


(* ========================================================================== *)

type t = Food | Gold | Iron | Paper

let str_to_res str = match String.lowercase_ascii str with
 | "iron"  -> Some Iron
 | "gold"  -> Some Gold
 | "paper" -> Some Paper
 | "food"  -> Some Food
 | _       -> None

let res_to_str res = match res with
	| Iron -> "Iron" | Gold -> "Gold"
	| Paper -> "Paper" | Food -> "Food"
	| _ -> ""

let find_res res lst =
	let find tup = match tup with
		| (kind, amt) when ((Some kind) = (str_to_res res)) -> true
		| _ -> false in
	try List.find find lst with
		| Not_found -> raise (Exception.Illegal "can't find resource")

let change_resource key amt lst =
	let (res, the_amt) = find_res key lst in
	let new_res = (res, the_amt + amt) in
	let list_without = List.filter (fun (the_res, amt) -> not (the_res = res)) lst in
		new_res::list_without

let rec add_resources list1 list2 =
 	let find_res res lst = try snd (List.find
 		(fun x -> match x with (amt, x) when amt = res -> true | _ -> false) lst)
 	with Not_found -> 0 in
 	match list2 with
 	| [] -> list1
 	| (res, amt)::t -> add_resources ((res, find_res res list1)::list1) t

(* (\* comprehensive list of resource amounts for every resource in the game *\) *)
(* let res_lst = [ *)
(*   ("Barker's Civ", [ *)
(*     (Food, 19); *)
(*     (Gold, 20); *)
(*     (Iron, 0); *)
(*    ]); *)
(*   ("David's Civ", [ *)
(*     (Food, 0); *)
(*     (Gold, 0); *)
(*     (Iron, 0); *)
(*   ]) *)
(* ] *)

(* let get_name = function *)
(*   | Food -> "Food" *)
(*   | Gold -> "Gold" *)
(*   | Iron -> "Iron" *)

(* let describe = function *)
(*   | Food -> "This is food" *)
(*   | Gold -> "This is gold" *)
(*   | Iron -> "This is iron" *)

(* let get_amt civ res = *)
(*   let civ_res = List.assoc civ res_lst in *)
(*   List.assoc res civ_res *)
