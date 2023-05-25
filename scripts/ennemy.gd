extends CharacterBody3D


@onready var rng = RandomNumberGenerator.new()

@onready var swordScene = preload("res://levels/weapons/Sword.tscn")
@onready var sword = swordScene.instantiate()
@onready var animatedSkinComponent: AnimatedSkinComponent = $AnimatedSkinComponent
@onready var healthComponent: HealthComponent = $HealthComponent
@onready var weaponSlotComponent: WeaponSlotComponent = $WeaponSlotComponent

@onready var velocityComponent: VelocityComponent = $VelocityComponent
@onready var lookAtComponent: LookAtComponent = $LookAtComponent
@onready var pathFindComponent: PathFindComponent = $PathFindComponent
@onready var tree := $BeehaveTree
@onready var blackboard := $Blackboard

@export var life = 10
@export var hurt_effects: Array[Resource]

var in_range=false
var is_attacking= false
var ready_to_attack = true 
var reloading = false;
var target: Node3D
var isDie:bool= false
var isStun:bool= false

@export var aimHero:bool =false

func _ready():
	healthComponent.health = life
	healthComponent.MAX_HEALTH = life
	
	if weaponSlotComponent !=null:
		weaponSlotComponent.equip(sword.duplicate())
		
	if animatedSkinComponent != null && weaponSlotComponent != null:
		weaponSlotComponent.set_external_skeleton(animatedSkinComponent.get_skeleton())
		weaponSlotComponent.bone_idx=animatedSkinComponent.get_right_hand_bone_index()
	pass

func start_attack():
	is_attacking=true
	ready_to_attack=false
	weaponSlotComponent.start_attack()
	animatedSkinComponent.start_attack()
	
func end_attack():
	weaponSlotComponent.end_attack()
	is_attacking=false
	reload()

func start_recovery_attack(): 
	weaponSlotComponent.start_recovery_attack()
		
func hurt(attack :Attack):
	animatedSkinComponent.start_hurt()
	isStun=true
	SoundManager.playImpactPlateSound()
	for hurt_effect in hurt_effects:
		hurt_effect.trigger_effect(self,attack)
	
func end_hurt():
	isStun=false

func die():
	if isDie == true:
		return
	weaponSlotComponent.end_attack()
	weaponSlotComponent.unequip()
	isDie=true
	animatedSkinComponent.die()
	move_and_slide()
	get_tree().call_group("level","ennemy_die",self)
	await get_tree().create_timer(3).timeout
	queue_free()
	

func get_random_time():
	return rng.randf_range(2,3)

func reload():
	reloading= true
	var time = get_random_time()
	await get_tree().create_timer(time).timeout
	reloading = false
	ready_to_attack=true
	
func _physics_process(delta):
	blackboard.set_value("delta",delta)
	# Add the gravity.
	if not is_on_floor():
		velocityComponent.apply_gravity(delta)
		velocityComponent.move(self,delta)
		animatedSkinComponent.walk(Vector2(),delta)
		return
	
	if isDie == true:
		velocityComponent.decelerate(delta)
		velocityComponent.move(self,delta)
		return
				
	#if ready_to_attack ==true && in_range == true:
	#	start_attack()
	
	#if is_attacking == false && isStun == false: 
	#	pathFindComponent.follow_path(self,delta)
	#	pathFindComponent.look_at_target(delta)
	#	var animation_blend = Vector2(velocityComponent.current_velocity.x,-velocityComponent.current_velocity.y).rotated(-rotation.y).normalized()
	#	animatedSkinComponent.walk(animation_blend,delta)
	#else:
	#	velocityComponent.decelerate(delta)
	#	
	#velocityComponent.move(self,delta)
	

func update_target_location(target_node: Node3D,hero_node: Node3D):
	if aimHero == true:
		target = hero_node
	else:
		target=target_node
	pathFindComponent.set_target_position_node(target)

func _on_path_find_component_velocity_computed(safe_velocity):
	pathFindComponent.on_velocity_computed(safe_velocity)
	pass # Replace with function body.

func _on_path_find_component_target_reached():
	in_range = true
	pass

func _on_path_find_component_path_changed():
	in_range = false
	print("change_path")
	pass # Replace with function body.


func _on_path_find_component_navigation_finished():
	in_range = false
	print("path_finished")
	pass # Replace with function body.
