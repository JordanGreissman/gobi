open game

module type AI = sig

  (* TODO are these lists of cmds? Are they variants? *)
  type entity_cmd

  type production_cmd

  type research_cmd

  type move_type

  val generate_command : move_type -> cmd 

  val attempt_move : state -> cmd -> state

  val attempt_turn : state -> state