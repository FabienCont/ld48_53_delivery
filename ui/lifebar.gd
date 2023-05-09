extends Node3D

@onready var lifebarMesh = $MeshInstance3D
@onready var label = $Sprite3D/SubViewport/Label

@export var max_life_value: int = 10 : set = update_life
@export var life_value: int = 5 : set = update_life

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_life(_value):
	label.text = str(life_value) +" / "+ str(max_life_value)
	
func set_life(life):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"life_value",life,0.5)

func set_max_life(max_life):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"life_value",max_life,0.5)
