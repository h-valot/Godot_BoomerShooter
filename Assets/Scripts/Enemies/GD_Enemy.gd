extends Node
class_name Enemy

@export var max_health : float = 100

var _current_health : float = max_health

func apply_damage(damage : float):
	_current_health -= damage
	print("ENEMY: damaged")
