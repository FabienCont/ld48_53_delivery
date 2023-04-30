extends Node

var stats: Dictionary = {
	"max_health":10,
	"life":10,
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

func endLevel():
	stats.totalSavedAllies+=stats.savedAllies
	stats.TotalKilledEnnemies+=stats.killedEnnemies
	stats.level+=1
