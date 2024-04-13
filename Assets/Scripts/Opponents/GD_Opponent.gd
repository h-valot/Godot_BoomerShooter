extends CharacterBody3D
class_name Opponent

@export_category("References")
@export var opponent_config : OpponentConfig
@export var target : Player

var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _health_component : HealthComponent = $PF_Health
@onready var _navigation_agent_3d = $NavigationAgent3D

signal on_opponent_dies

func _ready():
	_health_component.initialize(opponent_config.base_health, opponent_config.health_regeneration, opponent_config.base_armor)
	_health_component.connect("on_health_reached_zero", _die)

func _die():
	emit_signal("on_opponent_dies")
	self.queue_free()

func _physics_process(delta):
	_update_target_position()
	_apply_gravity(delta)
	_move(delta)
	move_and_slide()

func _update_target_position():
	_navigation_agent_3d.target_position = target.global_transform.origin

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta

func _move(delta):
	_direction = (_navigation_agent_3d.get_next_path_position() - global_transform.origin).normalized() * opponent_config.move_speed
	velocity = velocity.move_toward(_direction, 0.25)

func _jump():
	if is_on_floor():
		velocity.y = opponent_config.jump_force
