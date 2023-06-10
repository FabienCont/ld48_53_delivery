extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.has_target_to_attack == false :
		return SUCCESS
	else:
		return FAILURE
