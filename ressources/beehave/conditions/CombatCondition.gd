extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.has_target_to_attack == true :
		return SUCCESS
	else:
		return FAILURE
