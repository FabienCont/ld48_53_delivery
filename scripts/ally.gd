extends CharacterBody3D

@onready var remoteTransform3D: RemoteTransform3D
@onready var pathFollow3D: PathFollow3D
@onready var pathFollow3DTargetToLook: PathFollow3D
@onready var path3D: Path3D = get_node("/root/Level/Terrain/alliesPath")

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var life = 16 : set = update_life
var isDie= false
signal life_update(life)
var yOffset = 0.90
func _ready() -> void:
	pathFollow3D = PathFollow3D.new()
	pathFollow3D.loop = false
	
	pathFollow3DTargetToLook = PathFollow3D.new()
	pathFollow3DTargetToLook.loop = false
	
	remoteTransform3D = RemoteTransform3D.new()
	remoteTransform3D.position.y = 1.0
	remoteTransform3D.remote_path = self.get_path()
	
	path3D.add_child(pathFollow3DTargetToLook)
	path3D.add_child(pathFollow3D)
	#pathFollow3D.add_child(remoteTransform3D)
	
	global_transform = pathFollow3D.global_transform
	pass
	
func die():
	get_tree().call_group("level","ally_die",self)
	isDie=true
	rotate(Vector3.LEFT,deg_to_rad(90))
	move_and_slide()
	await get_tree().create_timer(3).timeout
	queue_free()

func escape():
	await get_tree().create_timer(1).timeout
	queue_free()
	
func update_life(value):
	if isDie: 
		return
	life = value
	print("ally life:"+str(value))
	emit_signal("life_update",value) 
	if life<= 0 :
		self.die()
	pass
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if isDie == true :
		move_and_slide()
		return
	
	pathFollow3D.progress +=  SPEED * delta
	
	pathFollow3DTargetToLook.progress =  pathFollow3D.progress +1
	
	global_transform = pathFollow3D.global_transform
	global_position.y+=yOffset
	
	var posToLookAt = pathFollow3DTargetToLook.position
	posToLookAt.y +=yOffset 
	look_at(posToLookAt)
	#move_and_slide()
