extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var base = $base
@onready var hand = $base/hand
@onready var weapon = $base/hand/weapon

var stats;

# Get the gravity from the
# project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var life = 10 : set = update_life
var isDie = false
signal life_update(life)

func _ready():
	stats = GlobalInfo.stats
	life= stats.life
	
func die():
	get_tree().call_group("level","player_die",self)
	rotate(Vector3.LEFT,deg_to_rad(90))
	move_and_slide()
	isDie = true
	
func update_life(value):
	if isDie == true:
		return
	stats.life = value
	life = stats.life
	print("player life:"+str(value))
	emit_signal("life_update",value) 
	if life<= 0 :
		die()
	pass
	
func attack():
	if isDie == true:
		return
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
		rotation.x = 0
		rotation.z = 0
	
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
	
	var input_look_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	var direction_look = (camera.global_transform.basis * Vector3(input_look_dir.x, 0, input_look_dir.y)).normalized()
	
	if(direction_look.x!= 0 && direction_look.y!= 0):
		look_at(position + direction_look)
		rotation.x = 0
		rotation.z = 0
	else:
		look_at_mouse()
	
func _physics_process(delta):
	if global_transform.origin.y < -50:
		die()
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if isDie == true:
		move_and_slide()
		return
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("action1"):
		self.attack()
		
	self.top_down_movement()
	move_and_slide()
	
func loot(type: String,value)-> void:
	stats[type]+=value
		
