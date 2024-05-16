extends Node
class_name HealthComponent

@export_category("Tweakable values")
## NEUTRAL can be damaged by every source of damage including itself. 
## PLAYER can be damaged by NEUTRAL and OPPONENT but not by itself.  
## OPPONENT can be damaged by PLAYER and NEUTRAL but not by itself.
@export_enum("NEUTRAL", "PLAYER", "OPPONENT") var receiver_type : int = 0 

var current_health : float
var current_armor : float

var _base_health : float
var _base_armor : float
var _health_regeneration : float
var _regeneration_timer : float

signal on_health_reached_zero
signal on_health_changed(new_health, delta)
signal on_armor_reached_zero
signal on_armor_changed(new_armor, delta)


func initialize(base_health : float, health_regeneration : float, base_armor: float):

	_base_health = base_health
	_base_armor = base_armor
	_health_regeneration = health_regeneration

	current_health = _base_health
	current_armor = _base_armor


func _process(delta):

	_regeneration_timer += delta
	if (_regeneration_timer >= 1):

		_regeneration_timer -= 1
		update_current_health(_health_regeneration)


func update_current_health(amount : float, causer_type : int = 0):

	# Check causer and receiver receiver_type
	if (causer_type != 0
	&& receiver_type == causer_type):
		return

	# Clamp heal to the max '_base_health'
	if (current_health + amount >= _base_health):

		current_health = _base_health
		return

	# Handle damage on 'current_armor'
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

	# Handle health
	current_health += amount

	if (current_health <= 0):

		current_health = 0
		on_health_reached_zero.emit()

	on_health_changed.emit(current_health, amount)
