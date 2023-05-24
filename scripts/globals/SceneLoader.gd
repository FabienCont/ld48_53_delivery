extends CanvasLayer

@onready var animation_player = $LoadingScreen/AnimationPlayer

func _ready() -> void:
	Signals.connect('level_loaded', _on_finish_load)

func change_scene_to_file(target: String) -> void:
	await _show_loading_screen
	_transition_dissolve_to_file(target)

func change_scene_to_packed(packedScene: PackedScene) -> void:
	_transition_dissolve_to_packed(packedScene)
	
func _show_loading_screen():
	animation_player.play("loading_screen")
	return animation_player.animation_finished

func _transition_dissolve_to_file(target: String) -> void:
	await _show_loading_screen()
	get_tree().change_scene_to_file(target)

func _transition_dissolve_to_packed(packedScene: PackedScene) -> void:
	await _show_loading_screen()
	get_tree().change_scene_to_packed(packedScene)
	
func _on_finish_load() -> void:
	_hide_loading_screen()

func _hide_loading_screen():
	animation_player.play_backwards("loading_screen")
