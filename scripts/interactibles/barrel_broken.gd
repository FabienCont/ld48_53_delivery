extends Node3D

@export var mass_pieces: float = 1.0
@onready var attack_origin: Attack 
@onready var barrel_model:= $barrel_broken_model

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var childrend = barrel_model.get_children()
	for child in childrend:
		print(child)
		if child is RigidBody3D:
			child.mass = mass_pieces
			if attack_origin is Attack :
				var impulse_direction = Vector3(child.global_transform.origin - attack_origin.attack_position).normalized()
				child.apply_central_impulse(impulse_direction * attack_origin.knockback_force)
	await get_tree().create_timer(5.0).timeout
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
