extends Node
class_name LookAtComponent

@onready var current_rotation:= Vector3()
@export var LERP_SPEED_FACTOR := 10.0
@export var observer:Node3D

func look():
	observer.rotation = current_rotation
	pass
func set_observer(node:Node3D):
	observer = node
	
func update_rotation(target_to_look: Vector3,delta: float):
	var diff = Vector3(observer.global_transform.origin-target_to_look)
	var angle = Vector2(diff.z,diff.x).normalized().angle()
	current_rotation.y = lerp_to_angle(current_rotation.y,angle,delta)
	current_rotation.x = lerp_to_angle(current_rotation.x,0.0,delta)
	current_rotation.z = lerp_to_angle(current_rotation.z,0.0,delta)

func lerp_to_angle(rotationValue: float, angle : float, delta : float):
	return lerp_angle(rotationValue,angle,delta*LERP_SPEED_FACTOR)
