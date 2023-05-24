extends Node

@onready var level1: PackedScene  = preload("res://levels/Level1.tscn")
@onready var level2: PackedScene  = preload("res://levels/Level2.tscn")
@onready var level3: PackedScene = preload("res://levels/Level3.tscn")

var stats: Dictionary = {
	"max_health":30,
	"life":30,
	"strenght":0,
	"money":0,
	"curse":0,
	"level":0,
	"speed":0,
	"speedAttack":0,
	"savedAllies":0,
	"totalSavedAllies":0,
	"killedEnnemies":0,
	"TotalKilledEnnemies":0
} 

var savedStats: Dictionary = {
	
}

func reset():
	stats.max_health= 10
	stats.strenght= 10	
	stats.life=10
	stats.money= 0
	stats.curse=0
	stats.level=0
	stats.speed=0
	stats.speedAttack=0
	stats.savedAllies=0
	stats.totalSavedAllies=0
	stats.killedEnnemies=0
	stats.TotalKilledEnnemies=0

func startLevel():
	stats.savedAllies=0
	stats.killedEnnemies=0
	savedStats = stats.duplicate(true)

func endLevel():
	stats.totalSavedAllies+=stats.savedAllies
	stats.TotalKilledEnnemies+=stats.killedEnnemies
	stats.level+=1


func goToMenu():
	get_tree().change_scene_to_file("res://Menu.tscn")

func goToNextLevel():
	if stats.level==3 :
		get_tree().change_scene_to_file("res://levels/menu/ThanksScreen.tscn")
	elif stats.level==2 :
		SceneLoader.change_scene_to_packed(level3)
	elif stats.level==1 :
		SceneLoader.change_scene_to_packed(level2)
	else:
		SceneLoader.change_scene_to_packed(level1)
	pass # Replace with function body.

func restartLevel():
	stats = savedStats.duplicate(true)
	if stats.level==2 :
		SceneLoader.change_scene_to_packed(level3)
	elif stats.level==1 :
		SceneLoader.change_scene_to_packed(level2)
	else:
		SceneLoader.change_scene_to_packed(level1)
	pass # Replace with function body.
