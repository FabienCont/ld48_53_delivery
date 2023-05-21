extends Node3D
class_name Weapon

@onready var audioStreamPlayer: AudioStreamPlayer3D = $attackAudioStreamPlayer;
@onready var collider: CollisionShape3D = $Area3D/CollisionShape3D
@onready var touched_ennemies= {}
@onready var is_attacking : bool = false

func is_parent_recursive(node:Node3D,body:Node3D) -> bool :
	var parent = node.get_parent()
	if parent == get_tree().get_root():
		return false
	elif parent == body:
		return true
	else:
		return is_parent_recursive(parent,body)

func start_attack():
	collider.disabled=false
	is_attacking = true
	touched_ennemies={}
	audioStreamPlayer.play()
	
func end_attack():
	collider.disabled=true
	is_attacking = false
		
func damage(hurtboxComponent :HurtboxComponent):
	var attack = Attack.new()
	attack.attack_damage = 4
	attack.attack_position = global_position
	hurtboxComponent.damage(attack)

func _on_area_3d_body_shape_entered(_body_rid: RID, body: Node3D, body_shape_index:int, _local_shape_index:int):
	if touched_ennemies.get(_body_rid) != null || is_attacking == false:
		return
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	var body_shape_node = body.shape_owner_get_owner(body_shape_owner)
	touched_ennemies[_body_rid]=true
	if body_shape_node is HurtboxComponent:
		if(!is_parent_recursive(self,body)):
			damage(body_shape_node)
