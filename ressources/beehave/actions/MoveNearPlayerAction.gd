extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isStun == false :
		var delta = blackboard.get_value("delta")
		actor.move_to_target(delta)
		return RUNNING
	else:
		return SUCCESS
	
func _finished(_actor: Node) -> void:
	pass
