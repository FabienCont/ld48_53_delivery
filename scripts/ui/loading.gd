@tool
extends Control

# Hides the loading screen when the scatter nodes are ready.
#
# Every Scatter nodes emit a signal called "build_completed" when they are done
# generating their multimeshes.

var _scatter_completed := false

func _ready() -> void:
	get_tree().paused = true
	
	# Show the loading screen, unless scatter is already done.
	visible = not _scatter_completed


func _on_proton_scatter_2_build_completed() -> void:
	visible = false
	_scatter_completed = true
	get_tree().paused = false
