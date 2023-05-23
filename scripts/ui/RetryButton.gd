extends Button

@onready var audioStreamPlayer:AudioStreamPlayer = get_tree().root.get_node("/root/Menu/AudioStreamPlayer")

func _on_pressed():
	audioStreamPlayer.play()
	GlobalInfo.restartLevel()
