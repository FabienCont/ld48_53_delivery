extends Button

@onready var audioStreamPlayer:AudioStreamPlayer = get_tree().root.get_node("/root/Menu/AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	audioStreamPlayer.play()
	GlobalInfo.restartLevel()
	get_tree().change_scene_to_file("res://Menu.tscn")
