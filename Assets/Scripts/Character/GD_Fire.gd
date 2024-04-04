extends Node

@export var weapon : Weapon
@export var debug_weapon_config : WeaponConfig

func _process(delta):
	_fire()

func _fire():
	# Handle weapon fire input
	if (Input.is_action_just_pressed("Fire")):
		weapon.fire(debug_weapon_config)
