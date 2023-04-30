extends Node3D

var level_parameters :={
	"loot":""
}
@onready var hero: CharacterBody3D =$Player/PlayerCharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var first_ally= get_tree().get_first_node_in_group("allies")
	if first_ally != null:
		get_tree().call_group("ennemies","update_target_location",first_ally)
	elif hero:
		get_tree().call_group("ennemies","update_target_location",hero)
	pass

func loose():
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://levels/LooseScreen.tscn")
	
func win():
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://levels/WinScreen.tscn")
	
func _on_player_character_body_3d_player_die():
	loose()
	
func ally_die(ally: Node3D):
	var allies = get_tree().get_nodes_in_group("allies")
	if(allies.size()==1 && allies[0] == ally ):
		loose()
	pass

func ally_escape(_ally: Node3D):
	pass
	
func ennemy_die(ennemy: Node3D):
	var ennemies = get_tree().get_nodes_in_group("ennemies")
	if(ennemies.size()==1 && ennemies[0] == ennemy ):
		open_doors()
	pass

func open_doors():
	get_tree().call_group("doors","open")

func body_exit(body):
	if(body == hero):
		win()
		
func loot():
	pass
