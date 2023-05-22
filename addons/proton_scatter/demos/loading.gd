extends Control

# Hides the loading screen when the scatter nodes are ready.
#
# Every Scatter nodes emit a signal called "build_completed" when they are done
# generating their multimeshes.

var _scatter_completed := false
@export var scatter_node: Node3D 

func _ready() -> void:
	if scatter_node:
		start_loading()
	else :
		end_loading()

func start_loading() -> void:
	if scatter_node && scatter_node.has_signal("build_completed") :
		scatter_node.connect("build_completed", end_loading)
		get_tree().paused = true
	else:
		end_loading()

func end_loading() -> void:
	_scatter_completed = true
	get_tree().paused = false
	visible = false
