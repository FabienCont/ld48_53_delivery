extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isStun == false :
		actor.update_target_position()
		if actor.pathFindComponent.distance_to_target() > 10:
			return FAILURE
		var delta = blackboard.get_value("delta")
		actor.move_to_target(delta)
		return RUNNING
	else:
		return SUCCESS
	
func _finished(_actor: Node) -> void:
	pass
