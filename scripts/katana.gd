extends Node3D

@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationStateMachine: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
# Called when the node enters the scene tree for the first time.
func _ready():
	animationStateMachine.travel("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass

func _on_area_3d_body_entered(body):
	if(body.get("life") && animationStateMachine.get_current_node() == "attack"):
		body.life-=3
		
func attack():
	animationStateMachine.travel("attack")
