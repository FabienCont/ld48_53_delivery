extends Node3D

@onready var target :Node3D = $"../Player/PlayerCharacterBody3D"
# Called when the node enters the scene tree for the first time.
var localPosSave
func _ready():
	localPosSave = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
