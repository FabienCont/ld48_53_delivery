extends CharacterBody3D

@onready var remoteTransform3D: RemoteTransform3D
@onready var pathFollow3D: PathFollow3D
@onready var path3D: Path3D = get_node("/root/Level/Terrain/Path3D")

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var life = 10 : set = update_life

signal life_update(life)
signal ally_die()
signal ally_escape()

func _ready() -> void:
	pathFollow3D = PathFollow3D.new()
	pathFollow3D.loop = false
	remoteTransform3D = RemoteTransform3D.new()
	remoteTransform3D.position.y = 1.0
	remoteTransform3D.remote_path = self.get_path()
	path3D.add_child(pathFollow3D)
	pathFollow3D.add_child(remoteTransform3D)
	pass
	
func die():
	emit_signal("ally_die")
	queue_free()

func escape():
	emit_signal("ally_escape")
	queue_free()
	
func update_life(value):
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
	
	pathFollow3D.progress +=  SPEED * delta
	if(pathFollow3D.progress_ratio>=1.0):
		escape()
	
	move_and_slide()
