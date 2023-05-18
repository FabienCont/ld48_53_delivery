extends Node
class_name HealthComponent

@export var MAX_HEALTH := 10.0
@export var health := 10.0

func _ready():
	if health == null:
		health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		var parent = get_parent();
		if parent.has_method("die"):
			parent.die();
		else: 
			parent.queue_free()
