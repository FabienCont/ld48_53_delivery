extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	
	actor.start_attack()
	
	if actor.is_attacking == false :
		return RUNNING
	else:
		return SUCCESS

func _finished(_actor: Node) -> void:
	pass
