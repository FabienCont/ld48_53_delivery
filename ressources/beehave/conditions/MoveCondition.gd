extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.target != null && actor.ready_to_attack == false && actor.has_target_to_attack == true && actor.is_attacking == false:
		return SUCCESS
	else:
		return FAILURE
