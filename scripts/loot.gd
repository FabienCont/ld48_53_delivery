extends Node3D

@export var type:String="money"
@export var value:int=5

@onready var anim:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("loot")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_3d_body_entered(body: Node3D):
	if body.has_method("loot"):
		body.call("loot",type,value)
		queue_free()
