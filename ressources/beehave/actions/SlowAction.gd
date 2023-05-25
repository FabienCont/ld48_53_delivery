extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = blackboard.get_value("delta")
	actor.velocityComponent.decelerate(delta)
	actor.velocityComponent.move(actor,delta)
	var animation_blend = Vector2(actor.velocityComponent.current_velocity.x,-actor.velocityComponent.current_velocity.y).rotated(-actor.rotation.y).normalized()
	actor.animatedSkinComponent.walk(Vector2(0,0),delta)
			
	if actor.is_attacking == false && actor.isStun == false :
		return SUCCESS
	else:
		return RUNNING
		
func _finished(_actor: Node) -> void:
	pass
