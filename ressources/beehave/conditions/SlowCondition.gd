extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	print(actor.is_attacking == true)
	if actor.is_attacking == true || actor.isStun == true :
		return SUCCESS
	else:
		return FAILURE
