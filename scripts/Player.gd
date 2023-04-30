extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var base = $base
@onready var hand = $base/hand
@onready var weapon = $base/hand/weapon
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var life = 10 : set = update_life

signal life_update(life)
signal player_die()

func die():
	emit_signal("player_die")
	
func update_life(value):
	life = value
	print("player life:"+str(value))
	emit_signal("life_update",value) 
	if life<= 0 :
		self.die()
	pass
	
func attack():
	if(weapon.get_child_count()==0):
		print("no weapon equiped")
		return
	weapon.get_child(0).call("attack")
		
func look_at_mouse():
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	var ray_target = ray_origin + ray_normal *2000
	
	var space_state= get_world_3d().direct_space_state
	
	var test = PhysicsRayQueryParameters3D.create(ray_origin,ray_target)
	var intersection = space_state.intersect_ray(test)
	
	if not intersection.is_empty():
		look_at(intersection.position)
	
func fps_movement () :
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	look_at_mouse()
	
func top_down_movement():
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	look_at_mouse()
	
func _physics_process(delta):
	if global_transform.origin.y < -50:
		self.die()
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("action1"):
		self.attack()
		
	self.top_down_movement()
