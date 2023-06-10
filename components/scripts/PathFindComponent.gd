extends NavigationAgent3D
class_name PathFindComponent

@export var lookAtComponent: LookAtComponent
@export var velocityComponent: VelocityComponent

@onready var target: Node3D

func set_target_position_node(node: Node3D):
	target=node
	set_target_position(node.global_position)

func follow_path(node: Node3D,delta: float):
	if is_navigation_finished():
		velocityComponent.decelerate(delta)
		return;
	
	var direction = (get_next_path_position() - node.global_position).normalized()
	
	velocityComponent.accelerate_in_direction(direction,delta)
	set_velocity(velocityComponent.current_velocity)
	
func on_velocity_computed(_velocity :Vector3):
	#var direction = velocity.normalized()
	#velocityComponent.accelerateInDirection(direction,1)
	pass

func look_at_target(delta:float):
	if target !=null :
		lookAtComponent.update_rotation_with_target_position(target.global_position,delta)
		lookAtComponent.look()
