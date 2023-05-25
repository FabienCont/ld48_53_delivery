extends Node3D

@export var target :Node3D
# Called when the node enters the scene tree for the first time.

var localPosSave
var posSave
var distance
func _ready():
	localPosSave = Vector3( global_transform.origin)
	if target : 
		posSave = Vector3( target.global_transform.origin)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if target == null:
		return
	if posSave == null:
		posSave = Vector3( target.global_transform.origin) 
		
	var diff = posSave-target.global_transform.origin
	global_transform.origin = localPosSave - diff

	#look_at(self.global_transform.origin, target.transform.basis.y)

	pass
