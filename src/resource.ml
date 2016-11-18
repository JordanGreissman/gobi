type t = {
	name: string;
	amount: int;
}

(* create a resource with a name, default 0 amount *)
let create_resource name = 
	{ name = name; amount = 0 }

(* increase / decrease the amount of a particular resource
 * use positive int to increase, negative int to decrease *)
let change_resource_amount resource amount_change =
  let amt = resource.amount in
  { resource with amount = amt + amount_change }

