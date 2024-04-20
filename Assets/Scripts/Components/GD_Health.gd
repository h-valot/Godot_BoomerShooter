extends Node
class_name HealthComponent

var _base_health : float
var _current_health : float
var _health_regeneration : float
var _base_armor : float
var _current_armor : float

var _regeneration_timer : float

signal on_health_reached_zero
signal on_health_changed
signal on_armor_reached_zero
signal on_armor_changed


func initialize(base_health : float, health_regeneration : float, base_armor: float):

	_base_health = base_health
	_current_health = _base_health
	_health_regeneration = health_regeneration
	_base_armor = base_armor
	_current_armor = _base_armor


func _process(delta):

	_regeneration_timer += delta
	if (_regeneration_timer >= 1):

		_regeneration_timer -= 1
		update_current_health(_health_regeneration)


func update_current_health(amount : float):

	# Clamp heal to the max '_base_health'
	if (_current_health + amount >= _base_health):
		_current_health = _base_health
		return

	# Handle damage on '_current_armor'
	if (amount < 0
		&& _current_armor > 0):

		_current_armor += amount
		emit_signal("on_armor_changed")

		if (_current_armor <= 0):

			amount = abs(_current_armor)
			_current_armor = 0
			emit_signal("on_armor_reached_zero")
		
		else:

			return

	# Handle health
	_current_health += amount
	emit_signal("on_health_changed")

	if (_current_health <= 0):

		_current_health = 0
		emit_signal("on_health_reached_zero")
