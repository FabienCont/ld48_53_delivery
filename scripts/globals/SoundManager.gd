@tool
extends Node

@onready var _soundQueuesByName :Dictionary  = {}
@onready var _soundPoolsByName :Dictionary = {}
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_soundQueuesByName["LootCoinSoundQueue"] = get_node("LootCoinSoundQueue")
	_soundQueuesByName["BackgroundSoundQueue"] = get_node("BackgroundSoundQueue")
	_soundPoolsByName["ImpactPlateSoundPool"] = get_node("ImpactPlateSoundPool")
	_soundPoolsByName["ImpactPlankSoundPool"] = get_node("ImpactPlankSoundPool")
	pass

func playBackgroundSound():
	get_sound_queue_by_name("BackgroundSoundQueue").play_sound()

func playLootCoinSound():
	get_sound_queue_by_name("LootCoinSoundQueue").play_sound()

func playImpactPlankSound():
	get_sound_pool_by_name("ImpactPlankSoundPool").play_random_sound()

func playImpactPlateSound():
	get_sound_pool_by_name("ImpactPlateSoundPool").play_random_sound()

func get_sound_queue_by_name(name: String) -> SoundQueue :
	return _soundQueuesByName[name]

func get_sound_pool_by_name(name: String) -> SoundPool :
	return _soundPoolsByName[name]
