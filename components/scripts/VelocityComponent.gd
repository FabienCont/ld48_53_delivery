extends Node
class_name VelocityComponent

@export var JUMP_VELOCITY = 4.5
@export var MAX_SPEED = 6.0
@export var SPEED_FACTOR = 4.0
@export var ACCELERATION_FACTOR = 50.0
@export var FRICTION = 15.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var current_velocity:= Vector3()

func move(characterBody3D : CharacterBody3D , _delta : float ):
	current_velocity = current_velocity.clamp(Vector3(-MAX_SPEED,-MAX_SPEED,-MAX_SPEED),Vector3(MAX_SPEED,MAX_SPEED,MAX_SPEED))
	characterBody3D.velocity = current_velocity
	characterBody3D.move_and_slide()

func jump():
	current_velocity.y = JUMP_VELOCITY
	
func apply_gravity(delta:float):
	current_velocity.y -= gravity * delta
	
func accelerate_in_direction(direction: Vector3, delta:float):
	accelerate_to_velocity(direction * SPEED_FACTOR ,delta)

func decelerate(delta:float):
	var ySpeed = current_velocity.y 
	accelerate_to_velocity(Vector3.ZERO * FRICTION,delta)
	current_velocity.y  = ySpeed
	
func accelerate_to_velocity(velocity: Vector3,delta:float):
	current_velocity = current_velocity.move_toward(velocity,delta * ACCELERATION_FACTOR)
