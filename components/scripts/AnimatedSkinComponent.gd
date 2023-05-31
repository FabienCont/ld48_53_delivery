extends Node
class_name AnimatedSkinComponent

@export var animationTree: AnimationTree;
@export var skeleton: Skeleton3D;

@onready var parent = get_parent()
@onready var comboAttackCounter :int =0 

func get_skeleton():
	return skeleton.get_path()
	
func get_right_hand_bone_index():
	return 24;
	
func die():
	animationTree.set("parameters/die/transition_request","true")
	
func start_hurt():
	animationTree.set("parameters/hurt/request",1)

func end_hurt():
	if parent.has_method("end_hurt") :
		parent.end_hurt()

func walk(animation_blend :Vector2, delta :float):
	var animation_blend_lerp =  lerp(animationTree.get("parameters/walk/blend_position"),animation_blend,delta*15)
	animationTree.set("parameters/walk/blend_position",animation_blend_lerp)

func start_attack_2():
	comboAttackCounter+=1
	print("start_attack_2")
	animationTree.set("parameters/attack_2/request",1)
	
func start_attack():
	comboAttackCounter+=1
	animationTree.set("parameters/attack/request",1)

func end_attack(numAttack:int):
	if comboAttackCounter == numAttack:
		comboAttackCounter=0
		if parent.has_method("end_attack") :
			parent.end_attack()

func attack_start_to_hurt():
	if parent.has_method("attack_start_to_hurt") :
		parent.attack_start_to_hurt()
	
func start_recovery_attack(_numAttack:int):
	if parent.has_method("start_recovery_attack") :
		parent.start_recovery_attack()
		
func jump():
	animationTree.set("parameters/state/transition_request","jump")
	
func land():
	if animationTree.get("parameters/state/current_state") == "jump":
		animationTree.set("parameters/state/transition_request","walk")
