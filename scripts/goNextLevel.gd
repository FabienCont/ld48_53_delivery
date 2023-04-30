extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	if GlobalInfo.stats.level==3 :
		get_tree().change_scene_to_file("res://levels/ThanksScreen.tscn")
	elif GlobalInfo.stats.level==2 :
		get_tree().change_scene_to_file("res://levels/Level3.tscn")
	elif GlobalInfo.stats.level==1 :
		get_tree().change_scene_to_file("res://levels/Level2.tscn")
	else:
		get_tree().change_scene_to_file("res://levels/Level1.tscn")
	pass # Replace with function body.
