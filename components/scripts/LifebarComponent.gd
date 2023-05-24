extends Node3D
class_name LifebarComponent

@export var healthComponent : HealthComponent
@onready var sprite3D: Sprite3D = $LifebarSprite3D
@onready var life_value:float
@onready var _display_life_value :float = 0.0 : 
		set(value): _update_display_life(value)
@onready var max_life_value:float

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	_display_life_value=life_value
	if(healthComponent is HealthComponent) :
		healthComponent.connect("update_health",set_life)
		healthComponent.connect("update_max_health",set_max_life)
		_force_update_health_info()
		pass
	
func _force_update_health_info():
	if(healthComponent is HealthComponent) :
		set_life(healthComponent.health)
		set_max_life(healthComponent.MAX_HEALTH)
	
func _update_display_life(display_life):
	if sprite3D:
		sprite3D.update_display_life(display_life,max_life_value)
	return display_life
	
func set_life(life):
	life_value = life
	var tween = get_tree().create_tween()
	tween.tween_property(self,"_display_life_value",life_value,0.1).from_current()

func set_max_life(max_life):
	max_life_value= max_life
	_update_display_life(_display_life_value)
