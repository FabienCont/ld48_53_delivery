extends Node3D

@onready var target :Node3D = $"../Player/PlayerCharacterBody3D"
# Called when the node enters the scene tree for the first time.

var localPosSave
var posSave
var distance
func _ready():
	posSave = Vector3( target.global_transform.origin)
	localPosSave = Vector3( global_transform.origin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !target:
		return
	
	var diff = posSave-target.global_transform.origin
	global_transform.origin = localPosSave -diff

	#look_at(self.global_transform.origin, target.transform.basis.y)

	pass
