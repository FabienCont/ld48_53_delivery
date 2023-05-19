extends Sprite3D
class_name LifebarComponent

@onready var sub_viewport: SubViewport = $SubViewport
@onready var label: Label = $SubViewport/Label
@onready var texture_progess_bar :TextureProgressBar = $SubViewport/TextureProgressBar

var life_value:float
var _display_life_value :float = 0.0 : 
		set(value): 
			_display_life_value = _update_display_life(value)
var max_life_value:float

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	set_texture(sub_viewport.get_texture())
	_update_display_life(_display_life_value)
	

func _update_display_life(display_life):
	if label != null:
		label.text = str(display_life) +" / "+ str(max_life_value)
	if texture_progess_bar != null && max_life_value > 0:	
		print((display_life/max_life_value)*100)
		print(texture_progess_bar.value)
		texture_progess_bar.value = (display_life/max_life_value)*100
	return display_life
	
func set_life(life):
	life_value = life
	_display_life_value= life
	#var tween = get_tree().create_tween()
	#tween.tween_property(self,"_display_life_value",_display_life_value,0.5)

func set_max_life(max_life):
	max_life_value= max_life
	_update_display_life(_display_life_value)
