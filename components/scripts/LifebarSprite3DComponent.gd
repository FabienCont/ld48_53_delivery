extends Sprite3D

@export var sub_viewport: SubViewport 
@export var label: Label 
@export var texture_progess_bar :TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	set_texture(sub_viewport.get_texture())
	

func update_display_life(display_life,max_life_value):
	if label != null:
		label.text = str(round(display_life)) +" / "+ str(round(max_life_value))
	if texture_progess_bar != null && max_life_value > 0:	
		texture_progess_bar.value = (display_life/max_life_value)*100
	return display_life

