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

func is_parent_recursive(node:Node3D,body:Node3D) -> bool :
	var parent = node.get_parent()
	if parent == get_tree().get_root() :
		return false
	elif parent == body:
		return true
	else:
		return is_parent_recursive(parent,body)
	
func _on_area_3d_body_entered(body: Node3D):
	if(body.get("life") && animationStateMachine.get_current_node() == "attack"):
		if(!is_parent_recursive(self,body)):
			body.life-=4
		
func attack():
	animationStateMachine.travel("attack")
