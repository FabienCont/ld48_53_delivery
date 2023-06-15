extends HurtEffectResource

const bloodParticuleScene = preload("res://particles/BloodParticuleEmitter.tscn")

static func trigger_effect(node :Node3D,attack :Attack)->void:
	var blood = bloodParticuleScene.instantiate()
	node.add_child(blood)
	blood.global_transform.origin = attack.attack_position
	return
