extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.has_target_to_attack == true :
		actor.select_target()
		return SUCCESS
	else:
		return FAILURE
