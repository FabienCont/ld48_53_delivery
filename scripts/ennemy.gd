extends CharacterBody3D


const SPEED = 3.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var rng = RandomNumberGenerator.new()
@onready var weapon:Node3D 
@onready var hand = $hand
@onready var katanaScene = preload("res://weapons/katana.tscn")
@onready var katana = katanaScene.instantiate()
@export var life = 10 : set = update_life

var ready_to_attack = false 
var reloading = false;
var target: Node3D
var isDie:bool= false

signal life_update(life)

func _ready():
	hand.add_child(katana.duplicate())
	pass
	
func die():
	get_tree().call_group("level","ennemy_die",self)
	isDie=true
	rotate(Vector3.LEFT,deg_to_rad(90))
	move_and_slide()
	await get_tree().create_timer(3).timeout
	queue_free()
	

func get_random_time():
	return rng.randf_range(0.8,2)

func reload():
	reloading= true
	var time = get_random_time()
	await get_tree().create_timer(time).timeout
	reloading = false
	ready_to_attack=true
	
func update_life(value):
	if isDie: 
		return
	life = value
	print("ennemy life:"+str(value))
	emit_signal("life_update",value) 
	if life<= 0 :
		self.die()
	pass
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if isDie == true:
		move_and_slide()
		return
		
	var newVelocity = Vector3(0,0,0)
	
	var currentLocation = global_transform.origin
	var nextLocation = nav_agent.get_next_path_position()
	var velocity_temp = (nextLocation-currentLocation) * SPEED
	newVelocity.x += velocity_temp.x
	newVelocity.z += velocity_temp.z
	position=position.move_toward(nextLocation,delta * SPEED)
	
		
	if ready_to_attack:
			ready_to_attack=false
			hand.get_child(0).call("attack")
	elif not reloading :
		reload()

	move_and_slide()
	nav_agent.set_velocity(newVelocity)
	if target :
		look_at(target.global_transform.origin, target.transform.basis.y)
		rotation.x = 0
		rotation.z = 0
	

func update_target_location(target_node: Node3D):
	target=target_node
	nav_agent.set_target_position(target.global_transform.origin)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity

func _on_navigation_agent_3d_target_reached():
	#print("in range")
	pass
	
