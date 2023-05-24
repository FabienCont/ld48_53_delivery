extends HurtEffectResource

const attackDamageParticule = preload("res://particles/AttackDamageParticule.tscn")

static func trigger_effect(node :Node3D,attack :Attack)->void:
	var attackDamageParticuleScene = attackDamageParticule.instantiate()
	attackDamageParticuleScene.attack_number=attack.attack_damage
	node.add_child(attackDamageParticuleScene)
	attackDamageParticuleScene.global_transform.origin = attack.attack_position
	return
	
