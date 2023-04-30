extends Node3D


@onready var ally: CharacterBody3D
@onready var hero: CharacterBody3D =$Player/PlayerCharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	ally= get_tree().get_first_node_in_group("allies")
	if ally != null:
		get_tree().call_group("ennemies","update_target_location",ally)
	elif hero:
		get_tree().call_group("ennemies","update_target_location",hero)
	pass


func _on_player_character_body_3d_player_die():
	print("test")
	hero.set_script(null)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://levels/LooseScreen.tscn")
	pass # Replace with function body.
