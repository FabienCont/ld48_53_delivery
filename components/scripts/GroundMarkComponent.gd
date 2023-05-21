@tool
extends MeshInstance3D
class_name GroundMarkComponent 

@onready var material: StandardMaterial3D = StandardMaterial3D.new()
@export var color_mark: Color :
	set = set_color

func _ready():
	material.albedo_color = color_mark
	material.transparency = 1
	set_surface_override_material(0,material)
	
func set_color(value):
	if material is StandardMaterial3D:
		material.albedo_color = value
	color_mark=value
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
