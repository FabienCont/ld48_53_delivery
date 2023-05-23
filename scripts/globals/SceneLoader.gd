extends CanvasLayer

@onready var animation_player = $LoadingScreen/AnimationPlayer

func _ready() -> void:
	Signals.connect('level_loaded', on_finish_load)
	
func change_scene_to_file(target: String) -> void:
	transition_dissolve_to_file(target)
	
func transition_dissolve_to_file(target: String) -> void:
	animation_player.play("loading_screen")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)

func on_finish_load() -> void:
	animation_player.play_backwards("loading_screen")
