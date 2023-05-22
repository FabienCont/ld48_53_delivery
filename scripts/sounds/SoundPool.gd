@tool
extends Node
class_name SoundPool

var _sounds: Array[SoundQueue] = []
var _random: RandomNumberGenerator = RandomNumberGenerator.new()
var _last_index :int = -1

func _ready():
	for child in get_children():
		if child is SoundQueue:
			_sounds.push_back(child)
			
func play_random_sound():
	var index = _random.randi_range(0, _sounds.size() -1 )
	if index == _last_index:
		index = _random.randi_range(0, _sounds.size() -1 )
	_last_index = index
	_sounds[index].play_sound()

func _get_configuration_warnings():
	var nbSoundQueue = 0
	for child in get_children():
		if child is SoundQueue:
			nbSoundQueue+=1
	if nbSoundQueue <2 :
		return ["Expected two or more children of type SoundQueue"]
	return []
