extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.ready_to_attack == false && actor.has_target_to_attack && actor.is_attacking == false :
		if actor.pathFindComponent.distance_to_target > 10:
			return FAILURE
			
		return SUCCESS
	else:
		return FAILURE
