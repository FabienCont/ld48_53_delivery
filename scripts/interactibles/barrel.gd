extends RigidBody3D

@onready var lootScene = preload("res://levels/interactibles/loot.tscn")
@onready var loot: = lootScene.instantiate();
@export var life = 8 : set = update_life
@onready var isDie= false
@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func has_loot():
	return rng.randi_range(0, 1)

func die():
	get_tree().call_group("level","barrel_die",self)
	isDie=true
	rotate(Vector3.LEFT,deg_to_rad(90))
	if has_loot(): 
		generate_loot()
	await get_tree().create_timer(0.5).timeout
	queue_free()

func hurt(attack :Attack):
	var impulse_direction =  Vector3(global_transform.origin - attack.attack_position).normalized()
	apply_central_impulse(impulse_direction * attack.knockback_force)
	SoundManager.playImpactPlankSound()
	
func generate_loot():
	loot.position = position + (transform.basis * Vector3(0, 0, 0.5))
	get_tree().get_root().add_child(loot.duplicate())
	
func update_life(value):
	if isDie: 
		return
	life = value
	print("barrel life:"+str(value))
	if life<= 0 :
		self.die()
	pass
