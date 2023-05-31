extends EffectResource

static func trigger_effect(node :Node3D,params)->void:
	var timeScale = 0.4
	var duration = 1.5
	Engine.time_scale = timeScale
	await node.get_tree().create_timer(duration*timeScale).timeout
	Engine.time_scale = 1.0
