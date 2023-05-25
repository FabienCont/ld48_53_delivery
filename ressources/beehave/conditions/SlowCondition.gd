extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.is_attacking == true || actor.isStun == true :
		return SUCCESS
	else:
		return FAILURE
