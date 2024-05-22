extends Node
class_name HealthComponent

@export_category("Tweakable values")
@export var receiver_type : Enums.HealthType = Enums.HealthType.NEUTRAL

var current_health : float
var current_armor : float

var _base_health : float
var _base_armor : float
var _health_regeneration : float
var _regeneration_timer : float

var _iframe_counter: float
var _iframe_duration: float
var _iframe_enabled: bool = false

var _is_immuned: bool = false

signal on_health_reached_zero
signal on_health_changed(new_health, delta)
signal on_armor_reached_zero
signal on_armor_changed(new_armor, delta)


func initialize(base_health : float, health_regeneration : float, base_armor: float, iframe_duration: float = 0):

	_base_health = base_health
	_base_armor = base_armor
	_health_regeneration = health_regeneration
	_iframe_duration = iframe_duration

	current_health = _base_health
	current_armor = _base_armor


func set_immunity(is_immuned: bool):

	_is_immuned = is_immuned


func _process(delta):
	_handle_iframe(delta)
	_handle_passive_regeneration(delta)


func _handle_iframe(delta):

	if (_iframe_duration <= 0):
		_iframe_enabled = false
		return;

	if (!_iframe_enabled):
		return;

	_iframe_counter += delta

	if (_iframe_counter >= _iframe_duration):

		_iframe_counter -= _iframe_duration
		_iframe_enabled = false


func _handle_passive_regeneration(delta):

	if (_health_regeneration == 0):
		return;

	_regeneration_timer += delta
	if (_regeneration_timer >= 1):

		_regeneration_timer -= 1
		update_current_health(_health_regeneration)


func update_current_health(amount : float, causer_type : int = 0):

	if (_is_immuned):
		return

	# check causer and receiver receiver_type
	if (causer_type != 0
	&& receiver_type == causer_type):
		return

	# clamp heal to the max '_base_health'
	if (current_health + amount >= _base_health):

		current_health = _base_health
		return

	# can not change armor & health during the iframe
	if (amount < 0
	&& _iframe_enabled):
		return
	
	# enable iframe
	if (amount < 0
	&& !_iframe_enabled):
		_iframe_enabled = true

	# handle damage on 'current_armor'
	if (amount < 0
	&& current_armor > 0):

		current_armor += amount

		if (current_armor <= 0):

			current_armor = 0
			on_armor_changed.emit(current_armor, amount)
			amount = abs(current_armor)
			on_armor_reached_zero.emit()
		
		else:

			on_armor_changed.emit(current_armor, amount)
			return

	# handle health
	current_health += amount

	if (current_health <= 0):

		current_health = 0
		on_health_reached_zero.emit()

	on_health_changed.emit(current_health, amount)
	print("current_health = ", current_health)
