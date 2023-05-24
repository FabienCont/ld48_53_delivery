extends Camera3D

@export var shaekableArea: Area3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_trauma(trauma_amount: float):
	if shaekableArea.has_method("add_trauma"):
		shaekableArea.add_trauma(trauma_amount)
