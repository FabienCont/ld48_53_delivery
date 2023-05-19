extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animatedSkinComponent: AnimatedSkinComponent = $AnimatedSkinComponent
@onready var healthComponent: HealthComponent = $HealthComponent
@onready var hitboxComponent: HitboxComponent = $HitboxComponent
@onready var weaponSlotComponent: WeaponSlotComponent = $WeaponSlotComponent
@onready var lifebarComponent: LifebarComponent = $LifebarComponent

var stats;

# Get the gravity from the
# project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var isDie = false
var isAttacking = false

func _ready():
	stats = GlobalInfo.stats
	healthComponent.health = stats.life
	if animatedSkinComponent != null && weaponSlotComponent != null:
		weaponSlotComponent.set_external_skeleton(animatedSkinComponent.get_skeleton())
		weaponSlotComponent.bone_idx=animatedSkinComponent.get_right_hand_bone_index()
	
func die():
	if isDie == true:
		return
	isDie = true
	get_tree().call_group("level","player_die",self)
	animatedSkinComponent.die()
	
func attack():
	if isDie == true:
		return
	if(not weaponSlotComponent.has_weapon_equiped()):
		print("no weapon equiped")
		return
	if  isAttacking == false:
		weaponSlotComponent.start_attack()
		isAttacking=true
		animatedSkinComponent.attack()
		velocity.x = 0
		velocity.z = 0

func end_attack(): 
	isAttacking=false
	weaponSlotComponent.end_attack()
	
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
		var animation_blend = Vector2(input_dir.x,-input_dir.y).rotated(camera.global_rotation.y).rotated(-rotation.y)
		animatedSkinComponent.walk(animation_blend,delta)

func _physics_process(delta):
	if global_transform.origin.y < -50:
		die()
		return
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else: 
		animatedSkinComponent.land()
	
	if isDie == true:
		move_and_slide()
		return
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animatedSkinComponent.jump()
	
	
	if Input.is_action_just_pressed("action1") && isAttacking == false:
		self.attack()
		
	if  isAttacking == false && is_on_floor():
		self.top_down_movement(delta)
	
	move_and_slide()
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())
	
func loot(type: String,value)-> void:
	stats[type]+=value
		
