extends CharacterBody3D

@onready var animatedSkinComponent: AnimatedSkinComponent = $AnimatedSkinComponent
@onready var healthComponent: HealthComponent = $HealthComponent
@onready var weaponSlotComponent: WeaponSlotComponent = $WeaponSlotComponent
@onready var controllerComponent: TopDownControllerComponent = $TopDownControllerComponent
@onready var velocityComponent: VelocityComponent = $VelocityComponent
@onready var lookAtComponent: LookAtComponent = $LookAtComponent

@export var die_effects: Array[Resource]
@export var hurt_effects: Array[Resource]

var stats;
var isDie = false
var isAttacking = false
var isStun = false
var isRecoveringAttack = false
var attackCombo = 0
var maxAttackCombo = 1

func _ready():
	stats = GlobalInfo.stats
	healthComponent.MAX_HEALTH = stats.max_health
	healthComponent.health = stats.life
	if animatedSkinComponent != null && weaponSlotComponent != null:
		weaponSlotComponent.set_external_skeleton(animatedSkinComponent.get_skeleton())
		weaponSlotComponent.bone_idx=animatedSkinComponent.get_right_hand_bone_index()
	
func die():
	if isDie == true:
		return
	isDie = true
	weaponSlotComponent.end_attack()
	weaponSlotComponent.unequip()
	get_tree().call_group("level","player_die",self)
	animatedSkinComponent.die()
	
	for die_effect in die_effects:
		die_effect.trigger_effect(self,null)

func hurt(attack :Attack):
	animatedSkinComponent.start_hurt()
	SoundManager.playImpactPlateSound()
	isStun=true
	
	for hurt_effect in hurt_effects:
		hurt_effect.trigger_effect(self,attack)
			
	shake_camera(0.8)
	
func hit(_attack :Attack):
	shake_camera(0.2)
	
func shake_camera(trauma_power:float):
	var camera := get_viewport().get_camera_3d()
	if camera is Camera3D && camera.has_method("add_trauma"):
		camera.add_trauma(trauma_power)
	
func end_hurt():
	isStun=false
	
func start_attack():
	if isRecoveringAttack == true && attackCombo<maxAttackCombo:
		attackCombo+=1
		animatedSkinComponent.start_attack_2()
		weaponSlotComponent.start_attack()
		return
	
	if isDie == true || isAttacking == true || not weaponSlotComponent.has_weapon_equiped():
		return
	animatedSkinComponent.start_attack()
	weaponSlotComponent.start_attack()
	isAttacking=true

func end_attack(): 
	attackCombo=0
	isAttacking=false
	isRecoveringAttack=false
	weaponSlotComponent.end_attack()

func attack_start_to_hurt():
	weaponSlotComponent.attack_start_to_hurt()
	
func start_recovery_attack():
	isRecoveringAttack=true
	weaponSlotComponent.start_recovery_attack()
		
func _physics_process(delta):
	if global_transform.origin.y < -10:
		die()
	
	if isDie == true:
		velocityComponent.decelerate(delta)
		velocityComponent.move(self,delta)
		return
			
	if not is_on_floor():
		velocityComponent.apply_gravity(delta)
	else: 
		animatedSkinComponent.land()
		if controllerComponent.jump():
			animatedSkinComponent.jump()
		elif controllerComponent.has_attack() && ((isAttacking == false|| isRecoveringAttack==true) && isStun == false) :
			start_attack()
		elif isAttacking == true || isStun == true:
			velocityComponent.decelerate(delta)
		elif isAttacking == false && isStun == false:
			var camera := get_viewport().get_camera_3d()
			controllerComponent.updateControl(delta, camera.global_rotation.y)
			if controllerComponent.has_move() : 
				var direction = controllerComponent.get_move_direction() * transform.basis
				var animation_blend = Vector2(direction.x,-direction.z)				
				animatedSkinComponent.walk(Vector2(animation_blend.x,animation_blend.y),delta)
			else:
				animatedSkinComponent.walk(Vector2(),delta)
			
	velocityComponent.move(self,delta)
	lookAtComponent.look()
	
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())
	
func loot(type: String,value)-> void:
	stats[type]+=value
		
