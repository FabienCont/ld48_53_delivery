extends Node
class_name HealthComponent

@export var MAX_HEALTH := 10.0
@export var health := 10.0
@export var lifebar_component: LifebarComponent
func _ready():
	if health == null:
		health = MAX_HEALTH
	if lifebar_component:
		lifebar_component.set_max_life(MAX_HEALTH)
		lifebar_component.set_life(health)

func damage(attack: Attack):
	print(attack)
	health -= attack.attack_damage
	if lifebar_component:
		lifebar_component.set_life(health)
	
	if health <= 0:
		var parent = get_parent();
		if parent.has_method("die"):
			parent.die();
