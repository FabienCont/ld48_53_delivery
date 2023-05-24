extends Node3D

@onready var isFinish:bool = false

@export var hero: CharacterBody3D
@export var spawner_allies: SpawnerComponent
@export var allies_path_3D: Path3D
@export var proton_scatter_node: Node3D

@onready var allyScene = preload("res://levels/characters/ally.tscn")
# Called when the node enters the scene tree for the first time.
var stats 
@export var timeToSpawn: float = 2
@export var nbAllyToSpawn: int = 1

func _ready():
	GlobalInfo.startLevel()
	SoundManager.playBackgroundSound()
	stats= GlobalInfo.stats
	get_tree().paused=true
	
	var ally_preparation_function = func(ally):
			ally.path3D = allies_path_3D
	
	if spawner_allies is SpawnerComponent:
		spawner_allies.scene_preparation_function = ally_preparation_function
		spawner_allies.nb_to_spawn = nbAllyToSpawn
		spawner_allies.interval_time_to_spawn = timeToSpawn
	if proton_scatter_node == null || not proton_scatter_node.has_signal("build_completed"):
		level_finish_to_load()
	else:
		proton_scatter_node.connect("build_completed",level_finish_to_load)
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var first_ally= get_tree().get_first_node_in_group("allies")
	if first_ally != null:
		get_tree().call_group("ennemies","update_target_location",first_ally,hero)
	elif hero:
		get_tree().call_group("ennemies","update_target_location",hero,hero)
	pass
	
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

func level_finish_to_load() -> void :
	Signals.emit_signal('level_loaded')
	get_tree().paused=false
