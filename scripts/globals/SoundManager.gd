@tool
extends Node

@onready var _soundQueuesByName :Dictionary  = {}
@onready var _soundPoolsByName :Dictionary = {}
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_soundQueuesByName["LootCoinSoundQueue"] = get_node("LootCoinSoundQueue")
	pass

func playLootCoinSound():
	get_sound_queue_by_name("LootCoinSoundQueue").play_sound()

func get_sound_queue_by_name(name: String) -> SoundQueue :
	return _soundQueuesByName[name]

func get_sound_pool_by_name(name: String) -> SoundPool :
	return _soundPoolsByName[name]
