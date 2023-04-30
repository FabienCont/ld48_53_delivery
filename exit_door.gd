extends Node3D

@onready var staticBody: StaticBody3D = $MeshInstance3D/StaticBody3D
# Called when the node enters the scene tree for the first time.

var isOpen: bool=false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func open():
	staticBody.queue_free()
	isOpen=true


func _on_area_3d_body_entered(body):
	get_tree().call_group("level","body_exit",body)
	pass # Replace with function body.
