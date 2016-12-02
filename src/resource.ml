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

let rec add_resources list1 list2 =
 	let find_res res lst = try snd (List.find
 		(fun x -> match x with res -> true | _ -> false) lst)
 	with Not_found -> 0 in
 	match list2 with
 	| [] -> list1
 	| (res, amt)::t -> add_resources ((res, find_res res list1)::list1) t

 let is_resource r = match r with
 	| Food | Gold | Iron | Paper -> true | _ -> false

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
