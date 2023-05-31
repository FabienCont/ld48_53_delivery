extends BoneAttachment3D
class_name WeaponSlotComponent

@export var weaponEquiped: Weapon;
@onready var parent:Node = get_parent()
func _ready() -> void:
	if has_weapon_equiped() :
		_listen_weapon_hit()

func _listen_weapon_hit():
	if weaponEquiped.has_signal("hit"):
		weaponEquiped.connect("hit",_hit_someone)
		
func _exit_tree():
	set_use_external_skeleton(false)
	set_external_skeleton('')
	
func has_weapon_equiped():
	return weaponEquiped != null
	
func equip(weapon: Weapon):
	weaponEquiped = weapon
	add_child(weapon)
	_listen_weapon_hit()

func unequip():
	remove_child(weaponEquiped)
	
func start_attack():
	if has_weapon_equiped() :
		weaponEquiped.start_attack()

func end_attack():
	if has_weapon_equiped() :
		weaponEquiped.end_attack()
		
func attack_start_to_hurt():
	if has_weapon_equiped() :
		weaponEquiped.attack_start_to_hurt()

func start_recovery_attack():
	if has_weapon_equiped() :
		weaponEquiped.start_recovery_attack()
		
func _hit_someone(attack :Attack):
	if parent.has_method("hit"):
		parent.hit(attack)
