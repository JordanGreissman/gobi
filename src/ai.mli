open game

module type AI = sig

  (* move_type corresponds to what the AI is currently trying to do
   * It is a variant that corresponds to moving an entity, chosing production,
   * chosing researc, etc... *)
  type move_type

  (* [generate_command] generates the cmd that corresponds 
   * to what the AI is trying to do*)
  val generate_command : move_type -> cmd 

  (* [attempt_move] is the state after cmd is executed at inputted state
   * It is the same state if the move is invalid *)
  val attempt_move : state -> cmd -> state

  (* [attempt_turn] is the state when the AI is done moving *)
  val attempt_turn : state -> state