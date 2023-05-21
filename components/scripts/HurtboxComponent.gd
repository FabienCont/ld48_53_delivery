extends CollisionShape3D
class_name HurtboxComponent

@export var health_component: HealthComponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
	var parent = get_parent()
	if parent.has_method("hurt") : 
		parent.hurt()
