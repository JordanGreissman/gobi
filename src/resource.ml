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

type t = Food | Gold | Iron

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
