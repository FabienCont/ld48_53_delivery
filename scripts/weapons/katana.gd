extends Node3D

@onready var audioStreamPlayer: AudioStreamPlayer3D = $attackAudioStreamPlayer
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
	#print(body)
	
	if(body.get("life") && animationStateMachine.get_current_node().contains("attack")):
		if(!is_parent_recursive(self,body)):
			var direction = Vector3(body.global_transform.origin - global_transform.origin).normalized()
			if(body.get("velocity") != null):
				body.velocity = direction *2
			elif(body.has_method("apply_central_impulse")):
				body.apply_central_impulse(direction *4)

				
			body.life-=4
		
func attack():
	if animationStateMachine.get_current_node()== "idle" :
		audioStreamPlayer.play()
		animationStateMachine.travel("attack_sword_2")
	elif animationStateMachine.get_current_node()== "recover" :
		audioStreamPlayer.play()
		animationStateMachine.travel("attack_sword_3")


func _on_rigid_body_3d_body_entered(body):	
	#print(body)

	if(body.get("life") && animationStateMachine.get_current_node().contains("attack")):
		if(!is_parent_recursive(self,body)):
			body.life-=4
	pass # Replace with function body.
