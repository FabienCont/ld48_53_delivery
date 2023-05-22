extends CharacterBody3D

@onready var animatedSkinComponent: AnimatedSkinComponent = $AnimatedSkinComponent
@onready var healthComponent: HealthComponent = $HealthComponent
@onready var weaponSlotComponent: WeaponSlotComponent = $WeaponSlotComponent
@onready var controllerComponent: TopDownControllerComponent = $TopDownControllerComponent
@onready var velocityComponent: VelocityComponent = $VelocityComponent
@onready var lookAtComponent: LookAtComponent = $LookAtComponent

var stats;
var isDie = false
var isAttacking = false
var isStun = false
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
	weaponSlotComponent.end_attack()
	get_tree().call_group("level","player_die",self)
	animatedSkinComponent.die()

func hurt(attack :Attack):
	animatedSkinComponent.start_hurt()
	SoundManager.playImpactPlateSound()
	isStun=true
	
func end_hurt():
	isStun=false
	
func start_attack():
	if isDie == true || isAttacking == true || not weaponSlotComponent.has_weapon_equiped():
		return
	weaponSlotComponent.start_attack()
	animatedSkinComponent.start_attack()
	isAttacking=true
		
func end_attack(): 
	isAttacking=false
	weaponSlotComponent.end_attack()
		
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
		elif isAttacking == true || isStun == true:
			velocityComponent.decelerate(delta)
		elif controllerComponent.has_attack() && (isAttacking == false && isStun == false) :
			start_attack()
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
		
