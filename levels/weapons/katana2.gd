extends Node3D
class_name Weapon

@onready var audioStreamPlayer: AudioStreamPlayer3D = $attackAudioStreamPlayer;
@onready var collider: CollisionShape3D = $Area3D/CollisionShape3D

func is_parent_recursive(node:Node3D,body:Node3D) -> bool :
	var parent = node.get_parent()
	if parent == get_tree().get_root() :
		return false
	elif parent == body:
		return true
	else:
		return is_parent_recursive(parent,body)

func start_attack():
	collider.disabled=false
	audioStreamPlayer.play()
	
func end_attack():
	collider.disabled=true
		
func damage(hitboxComponent :HitboxComponent):
	var attack = Attack.new()
	attack.attack_damage = 10
	attack.attack_position = global_position
	hitboxComponent.damage(attack)
	pass


func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body)
	if body is HitboxComponent:
		if(!is_parent_recursive(self,body)):
			var direction = Vector3(body.global_transform.origin - global_transform.origin).normalized()
			
			damage(body)
	pass # Replace with function body.
