extends Node
class_name Opponent

@export_category("References")
@export var opponent_config : OpponentConfig
@export var health_component : HealthComponent
@export var motor_component : OpponentMotor
@export var target : Player

signal on_opponent_dies

func _ready():
	health_component.initialize(opponent_config.base_health, opponent_config.health_regeneration, opponent_config.base_armor)
	health_component.connect("on_health_reached_zero", _die)
	motor_component.initialize(opponent_config)
	motor_component.set_new_target(target)

func _die():
	emit_signal("on_opponent_dies")
	self.queue_free()

