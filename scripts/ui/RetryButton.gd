extends Button

@onready var audioStreamPlayer:AudioStreamPlayer = get_tree().root.get_node("/root/Menu/AudioStreamPlayer")

func _on_pressed():
	audioStreamPlayer.play()
	GlobalInfo.restartLevel()
	get_tree().change_scene_to_file("res://Menu.tscn")
