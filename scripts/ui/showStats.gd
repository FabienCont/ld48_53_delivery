extends Control


# Called when the node enters the scene tree for the first time.

var stats= GlobalInfo.stats

@onready var ennemiesKilledLabel: Label = $HBoxContainer2/ennemiesKilledValue
@onready var moneyLabel: Label = $HBoxContainer/moneyValue
@onready var savedAlliesLabel: Label = $HBoxContainer3/savedValue
@onready var totalEnnemiesKilledLabel: Label = $HBoxContainer5/totalEnemiesKilledValue
@onready var totalSavedAlliesLabel: Label = $HBoxContainer6/totalSavedValue
@onready var levelLabel: Label = $HBoxContainer4/levelValue

func _ready():
	ennemiesKilledLabel.text = str(stats.killedEnnemies)
	moneyLabel.text= str(stats.money)
	savedAlliesLabel.text = str(stats.savedAllies)
	totalEnnemiesKilledLabel.text = str(stats.TotalKilledEnnemies)
	totalSavedAlliesLabel.text= str(stats.totalSavedAllies)
	levelLabel.text = str(stats.level)

