@tool
extends Node
class_name SoundQueue

var _next : int=0
var _audioStreamPlayers : Array[AudioStreamPlayer] = []
@export var count :=1

func _ready():
	var child = get_child(0)
	if child is AudioStreamPlayer:
		_audioStreamPlayers.push_back(child)
		for i in count-1:
			var duplicateAudioStreamPlayer: AudioStreamPlayer = child.duplicate()
			add_child(duplicateAudioStreamPlayer)
			_audioStreamPlayers.push_back(duplicateAudioStreamPlayer)

func play_sound():
	if not _audioStreamPlayers[_next].playing :
		_audioStreamPlayers[_next].play()
		_next = _next+1
		_next %= _audioStreamPlayers.size()
		
func _get_configuration_warnings():
	if get_child_count() == 0 :
		return ["No children found, Excepted one AudioStreamPlayer child"]
	if not (get_child(0) is AudioStreamPlayer):
		return ["Expected first child to be AudioStreamPlayer"]
	return []
