extends Node3D

var isFinish:bool = false


@onready var hero: CharacterBody3D =$Player/PlayerCharacterBody3D
@onready var allyScene = preload("res://levels/characters/ally.tscn")
@onready var ally_instance = allyScene.instantiate()
@onready var allies_node: Node3D=$Allies
# Called when the node enters the scene tree for the first time.
var stats 
var spawning:bool = false 
@export var timeToSpawn: float = 2
@export var nbAllyToSpawn: int = 1
var spawnAllyCounter:int =0

func _ready():
	GlobalInfo.startLevel()
	stats= GlobalInfo.stats
	pass # Replace with function body.

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var first_ally= get_tree().get_first_node_in_group("allies")
	if first_ally != null:
		get_tree().call_group("ennemies","update_target_location",first_ally,hero)
	elif hero:
		get_tree().call_group("ennemies","update_target_location",hero,hero)
	pass
	
	if(not spawning && spawnAllyCounter<nbAllyToSpawn):
		spawnAlly()

func spawnAlly():
	print("SPAWN ALLY")
	spawning=true
	spawnAllyCounter+=1
	allies_node.add_child(ally_instance.duplicate())
	await get_tree().create_timer(timeToSpawn).timeout
	spawning=false
	
func loose():
	if hasFinish():
		return
	isFinish=true
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://levels/menu/LooseScreen.tscn")
	
func win():
	if hasFinish():
		return
	isFinish=true
	GlobalInfo.endLevel()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://levels/menu/WinScreen.tscn")
	
func player_die(_player: Node3D):
	loose()
	
func ally_die(ally: Node3D):
	ally.remove_from_group("allies")
	var allies = get_tree().get_nodes_in_group("allies")
	if(allies.size()==0):
		loose()
	pass

func ally_escape(ally: Node3D):
	ally.remove_from_group("allies")
	ally.call("escape")
	stats.savedAllies+=1
	var allies = get_tree().get_nodes_in_group("allies")
	if(allies.size()==0):
		open_doors()
	
func ennemy_die(ennemy: Node3D):
	ennemy.remove_from_group("ennemies")
	stats.killedEnnemies+=1
	var allies = get_tree().get_nodes_in_group("allies")
	if(allies.size()==0):
		open_doors()
	pass

func open_doors():
	if hasFinish():
		return
	get_tree().call_group("doors","open")

func body_exit(body):
	if(body == hero):
		win()
	else:
		ally_escape(body)
		
func loot():
	if hasFinish():
		return
	pass

func hasFinish()-> bool:
	return isFinish == true
