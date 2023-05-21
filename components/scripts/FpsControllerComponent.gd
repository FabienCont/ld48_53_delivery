class_name FpsControllerComponent
extends Node

@export var lookAtComponent: LookAtComponent
@export var velocityComponent: VelocityComponent
@export var MOUSE_SENSITIVIY :float = 0.1
@onready var defaultBasis = Basis()
@onready var has_move_this_frame = false
@onready var move_this_frame:= Vector3()
@onready var mouse_relative:= Vector2()

func _unhandled_input(event: InputEvent)-> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouse_relative =  event.relative
			
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
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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
		lookAtComponent.update_rotation_with_angle(direction_to_look,delta)

func look_at_mouse(delta:float):
	if mouse_relative != null && mouse_relative.x !=0 :
		lookAtComponent.update_rotation_with_angle(-mouse_relative.x*MOUSE_SENSITIVIY,delta)
		mouse_relative=Vector2(0,0)
	
