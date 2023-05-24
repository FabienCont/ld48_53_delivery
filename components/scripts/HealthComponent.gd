extends Node
class_name HealthComponent

signal update_health(value: float)
signal update_max_health(value: float)

@export var MAX_HEALTH :float= 10.0 : 
	set= _set_max_life
		
@export var health :float= 10.0 :
	set= _set_life
		
func _ready():
	if health == null:
		health = MAX_HEALTH
	
	update_health.emit(health)
	update_max_health.emit(MAX_HEALTH)

func _set_max_life(max_life_value:float) : 
	update_max_health.emit(max_life_value)
	MAX_HEALTH = max_life_value
	
func _set_life(life_value:float) :
	update_health.emit(life_value)
	health = life_value
	
func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		var parent = get_parent();
		if parent.has_method("die"):
			parent.die();

	
