extends Node3D
class_name LifebarComponent

@export var sprite3D: Sprite3D

@onready var life_value:float
@onready var _display_life_value :float = 0.0 : 
		set(value): _update_display_life(value)
@onready var max_life_value:float

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	_display_life_value=life_value

func _update_display_life(display_life):
	sprite3D.update_display_life(display_life,max_life_value)
	return display_life
	
func set_life(life):
	life_value = life
	var tween = get_tree().create_tween()
	tween.tween_property(self,"_display_life_value",life,0.1).from_current()

func set_max_life(max_life):
	max_life_value= max_life
	_update_display_life(_display_life_value)
