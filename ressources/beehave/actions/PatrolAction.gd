extends ActionLeaf

func before_run(actor: Node, _blackboard: Blackboard) -> void:
	actor.select_target()
	
func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = blackboard.get_value("delta")
	actor.move_to_target(delta)
	
	if actor.has_target_to_attack == true:
		actor.select_target()
		return SUCCESS
	else:
		return RUNNING
		
func _finished(_actor: Node) -> void:
	pass
