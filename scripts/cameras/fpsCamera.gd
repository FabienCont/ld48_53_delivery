@tool
extends Node3D

@export var target_to_follow : Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	if target_to_follow:
		global_transform = target_to_follow.global_transform 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_to_follow:
		global_transform = target_to_follow.global_transform 
	pass
