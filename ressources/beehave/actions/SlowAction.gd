extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = blackboard.get_value("delta")
	actor.decelerate(delta)
	
	if actor.is_attacking == false && actor.isStun == false :
		return SUCCESS
	else:
		return RUNNING
		
func _finished(_actor: Node) -> void:
	pass
