extends Area3D
class_name InteractionArea3d

@onready var _collision_shape : CollisionShape3D = $CollisionShape3D
@onready var _shape : SphereShape3D =  _collision_shape.shape
@onready var _body_in_area :Array[PhysicsBody3D] = []

@export var size: float = 7.0

@onready var parent: Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	_shape.radius = size
	pass # Replace with function body.

func get_body_count_in_area() -> int:
	return _body_in_area.size()

func get_nearest_body() -> PhysicsBody3D:
	var min_distance = size * 2
	var nearest_body = null
	var indicesToRemove = []
	for index in _body_in_area.size():
		var body = _body_in_area[index]
		if (body != null && body.isDie == true):
			indicesToRemove.push_back(index)
		else :
			var distance = body.global_transform.origin.distance_to(global_transform.origin)
			if distance < min_distance:
				min_distance = distance
				nearest_body = body
			
	#for indexToRemove in indicesToRemove:
		#_body_in_area.remove_at(indexToRemove)
		
	return nearest_body

func _on_body_entered(body:PhysicsBody3D) -> void:
	print("_on_body_entered"+str(body))
	if body.get("isDie") != null && body.isDie == false:
		print("body found")
		_body_in_area.push_back(body)
		if parent.has_method("select_target") :
			parent.select_target()

func _on_body_exited(body) -> void:
	print("_on_body_exited"+str(body))
	var index = _body_in_area.find(body)
	if index != -1:
		_body_in_area.remove_at(index)
	if parent.has_method("select_target") :
			parent.select_target()
