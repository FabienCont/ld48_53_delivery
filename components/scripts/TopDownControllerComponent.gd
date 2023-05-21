class_name TopDownControllerComponent
extends Node

@export var lookAtComponent: LookAtComponent
@export var velocityComponent: VelocityComponent

@onready var defaultBasis = Basis()
@onready var has_move_this_frame = false
@onready var move_this_frame:= Vector3()

func has_move() -> bool:
	return has_move_this_frame
	
func get_move_direction() -> Vector3 :
	return move_this_frame

func reset_move():
	has_move_this_frame = false
	move_this_frame = Vector3()
	
func save_move(move: Vector3):
	has_move_this_frame = true
	move_this_frame = move
	
func has_attack() -> bool:
	if Input.is_action_just_pressed("action1"):
		return true 
	return false
		
func jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		velocityComponent.jump()
		return true 
	return false
	
func updateControl(delta,angle :float):
	reset_move()
	if angle == null:
		angle = 0.0
			
	update_velocity(angle,delta)
	update_look_direction(angle,delta)

func get_input_direction():
	return Input.get_vector("left", "right", "up", "down")
	
func update_velocity(angle :float,delta):
	if velocityComponent == null:
		return
	var input_dir = get_input_direction()

	if input_dir.x == 0 && input_dir.y == 0 :
		velocityComponent.decelerate(delta)	
	else:
		var direction = (Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3(0.0,1.0,0.0),angle)).normalized()
		save_move(direction)
		velocityComponent.accelerate_in_direction(direction,delta)
	
func update_look_direction(angle :float,delta:float):
	if lookAtComponent == null:
		return
	var input_look_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	if(input_look_dir.x == 0 && input_look_dir.y == 0):
		look_at_mouse(delta)
	else :
		var direction_to_look = (angle * Vector3(input_look_dir.x, 0, input_look_dir.y)).normalized()
		lookAtComponent.update_rotation(direction_to_look,delta)

func look_at_mouse(delta:float):
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	var ray_target = ray_origin + ray_normal *100
	
	var space_state= camera.get_world_3d().direct_space_state
	
	var test = PhysicsRayQueryParameters3D.create(ray_origin,ray_target)
	var intersection = space_state.intersect_ray(test)
	
	if not intersection.is_empty():
		lookAtComponent.update_rotation_with_target_position(intersection.position,delta)

