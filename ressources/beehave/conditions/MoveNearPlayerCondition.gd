extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.ready_to_attack == false && actor.has_target_to_attack  :
		return SUCCESS
	else:
		return FAILURE
