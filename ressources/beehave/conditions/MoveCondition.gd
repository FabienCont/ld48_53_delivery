extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.target !=null && actor.has_target_to_attack:
		return SUCCESS
	else:
		return FAILURE
