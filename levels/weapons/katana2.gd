extends Node3D
class_name Weapon

@onready var audioStreamPlayer: AudioStreamPlayer3D = $attackAudioStreamPlayer;
@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var touched_ennemies= {}
@onready var attack_can_hurt : bool = false
@onready var trail :GPUParticles3D = $AttackTrail
signal hit(attack:Attack)

func is_parent_recursive(node:Node3D,body:Node3D) -> bool :
	var parent = node.get_parent()
	if parent == get_tree().get_root():
		return false
	elif parent == body:
		return true
	else:
		return is_parent_recursive(parent,body)

func start_attack():
	touched_ennemies={}

func attack_start_to_hurt():
	attack_can_hurt = true
	collider.disabled=false
	audioStreamPlayer.play()
	trail.emitting =true
	
func start_recovery_attack():
	collider.disabled=true
	trail.emitting = false
	attack_can_hurt = false
	
func end_attack():
	pass
	
func damage(hurtboxComponent :HurtboxComponent):
	var attack = Attack.new()
	attack.attack_damage = 4
	attack.knockback_force = 2
	attack.attack_position = global_position
	hurtboxComponent.damage(attack)
	hit.emit(attack)
	
func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index:int, _local_shape_index:int):
	if touched_ennemies.get(body_rid) != null || attack_can_hurt == false:
		return
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	var body_shape_node = body.shape_owner_get_owner(body_shape_owner)
	touched_ennemies[body_rid]=true
	if body_shape_node is HurtboxComponent:
		if(!is_parent_recursive(self,body)):
			damage(body_shape_node)
