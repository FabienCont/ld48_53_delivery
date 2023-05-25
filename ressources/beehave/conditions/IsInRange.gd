extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.in_range == true:
		return SUCCESS
	else:
		return FAILURE
