extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var weapon = $BoneAttachment3D/weapon
@onready var animationTree: AnimationTree = $AnimationTree
var stats;

# Get the gravity from the
# project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var life = 10 : set = update_life
var isDie = false
var isAttacking = false
signal life_update(life)

func _ready():
	stats = GlobalInfo.stats
	life= stats.life
	
func die():
	get_tree().call_group("level","player_die",self)
	isDie = true
	animationTree.set("parameters/die/transition_request","true")
	
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
	if  isAttacking == false:
		isAttacking=true
		animationTree.set("parameters/attack/request",1)
		velocity.x = 0
		velocity.z = 0
		await get_tree().create_timer(1).timeout
		isAttacking=false

func look_at_mouse(delta):
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	var ray_target = ray_origin + ray_normal *100
	
	var space_state= get_world_3d().direct_space_state
	
	var test = PhysicsRayQueryParameters3D.create(ray_origin,ray_target)
	var intersection = space_state.intersect_ray(test)
	
	if not intersection.is_empty():
		var diff = Vector3(global_transform.origin-intersection.position)
		var angle = Vector2(diff.z,diff.x).normalized().angle()
		rotation.y = lerp_angle(rotation.y,angle,delta*10)
		#intersection.position
		#look_at(intersection.position)
		
		rotation.x = 0
		rotation.z = 0
	
	
func fps_movement (delta) :
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	look_at_mouse(delta)
	
func top_down_movement(delta):
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
		look_at_mouse(delta)
	var animation_blend =  lerp(animationTree.get("parameters/walk/blend_position"),Vector2(input_dir.x,-input_dir.y).rotated(camera.global_rotation.y).rotated(-rotation.y),delta*15)
	animationTree.set("parameters/walk/blend_position",animation_blend)
	
func _physics_process(delta):
	if global_transform.origin.y < -50:
		die()
		return
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif animationTree.get("parameters/state/current_state") == "jump":
		animationTree.set("parameters/state/transition_request","walk")
	
	if isDie == true:
		move_and_slide()
		return
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animationTree.set("parameters/state/transition_request","jump")
	
	
	if Input.is_action_just_pressed("action1") && isAttacking == false:
		self.attack()
		
	
	if  isAttacking == false && is_on_floor():
		self.top_down_movement(delta)
	
	move_and_slide()
	
func loot(type: String,value)-> void:
	stats[type]+=value
		
