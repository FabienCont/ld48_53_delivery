extends Node3D

@onready var attack_number:float
@onready var label: Label = $Sprite3D/SubViewport/Node2D/Label
@onready var animation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "- "+str(attack_number)
	top_level=true
	var tween = get_tree().create_tween()
	pass # Replace with function body.


func _remove():
	queue_free()
