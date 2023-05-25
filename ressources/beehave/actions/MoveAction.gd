extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isStun == false :
		var delta = blackboard.get_value("delta")
		actor.pathFindComponent.follow_path(actor,delta)
		actor.pathFindComponent.look_at_target(delta)
		var animation_blend = Vector2(actor.velocityComponent.current_velocity.x,-actor.velocityComponent.current_velocity.y).rotated(-actor.rotation.y).normalized()
		actor.animatedSkinComponent.walk(animation_blend,delta)
		actor.velocityComponent.move(actor,delta)
		return RUNNING
	else:
		return SUCCESS
	
func _finished(_actor: Node) -> void:
	pass
