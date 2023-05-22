extends CharacterBody3D

@onready var pathFollow3D: PathFollow3D
@onready var pathFollow3DTargetToLook: PathFollow3D
@onready var path3D: Path3D
@onready var healthComponent: HealthComponent = $HealthComponent
@onready var hurtboxComponent: HurtboxComponent = $HurtboxComponent

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var isDie= false
var yOffset = 0.90
func _ready():
	pathFollow3D = PathFollow3D.new()
	pathFollow3D.loop = false
	
	pathFollow3DTargetToLook = PathFollow3D.new()
	pathFollow3DTargetToLook.loop = false
	
	path3D.add_child(pathFollow3DTargetToLook)
	path3D.add_child(pathFollow3D)
	
	global_transform = pathFollow3D.global_transform
	pass
	
func die():
	if isDie == true:
		return
	isDie=true
	get_tree().call_group("level","ally_die",self)
	rotate(Vector3.LEFT,deg_to_rad(90))
	move_and_slide()
	await  get_tree().create_timer(3).timeout
	queue_free()

func escape():
	await  get_tree().create_timer(1).timeout
	queue_free()

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
