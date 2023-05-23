extends BoneAttachment3D
class_name WeaponSlotComponent

@export var weaponEquiped: Weapon;

func _exit_tree():
	set_use_external_skeleton(false)
	set_external_skeleton('')
	
func has_weapon_equiped():
	return weaponEquiped != null
	
func equip(weapon: Weapon):
	weaponEquiped = weapon
	add_child(weapon)

func unequip():
	remove_child(weaponEquiped)
	
func start_attack():
	if has_weapon_equiped() :
		weaponEquiped.start_attack()

func end_attack():
	if has_weapon_equiped() :
		weaponEquiped.end_attack()

func start_recovery_attack():
	if has_weapon_equiped() :
		weaponEquiped.start_recovery_attack()
