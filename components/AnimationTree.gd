extends AnimationTree

var parent 
func _ready():
	parent= get_parent()
func end_attack():
	if parent.has_method("end_attack") :
		parent.end_attack()
	
func start_recovery_attack():
	if parent.has_method("start_recovery_attack") :
		parent.start_recovery_attack()
