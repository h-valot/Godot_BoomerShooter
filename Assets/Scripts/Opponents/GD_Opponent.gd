extends RigidBody3D
class_name Opponent

@export_group("References")
@export var opponent_config : OpponentConfig
@export var health_component : HealthComponent

signal on_opponent_dies

func _ready():
	health_component.initialize(opponent_config.base_health, opponent_config.health_regeneration, opponent_config.base_armor)
	health_component.connect("on_health_reached_zero", _die)

func _die():
	emit_signal("on_opponent_dies")
	self.get_parent().queue_free()
