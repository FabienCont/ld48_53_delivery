extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.target !=null && actor.pathFindComponent.distance_to_target() < 15:
		return SUCCESS
	else:
		return FAILURE
