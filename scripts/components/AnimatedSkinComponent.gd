extends Node
class_name AnimatedSkinComponent

@export var animationTree: AnimationTree;
@export var skeleton: Skeleton3D;

func get_skeleton():
	return skeleton.get_path()
	
func get_right_hand_bone_index():
	return 24;
	
func die():
	animationTree.set("parameters/die/transition_request","true")
	
func walk(animation_blend :Vector2, delta :float):
	var animation_blend_lerp =  lerp(animationTree.get("parameters/walk/blend_position"),animation_blend,delta*15)
	animationTree.set("parameters/walk/blend_position",animation_blend_lerp)
	
func attack():
	animationTree.set("parameters/attack/request",1)
	
func end_attack():
	var parent = get_parent()
	if parent.has_method("end_attack") :
		parent.end_attack()
		
func jump():
	animationTree.set("parameters/state/transition_request","jump")
	
func land():
	if animationTree.get("parameters/state/current_state") == "jump":
		animationTree.set("parameters/state/transition_request","walk")
