extends CharacterBody3D
class_name OpponentMotor

var _target : Player
var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _opponent_config : OpponentConfig
var _initialized : bool = false

func initialize(opponent_config : OpponentConfig):
	_opponent_config = opponent_config
	_initialized = true

func set_new_target(target : Player):
	_target = target

func _physics_process(delta):
	if (!_initialized):
		return
	
	_apply_gravity(delta)
	_move(delta)
	move_and_slide()

func _move(delta):
	if (_target == null):
		return
	
	var _new_direction = (_target.player_motor.position - position).normalized()
	_direction = lerp(_direction, _new_direction, delta * _opponent_config.acceleration)
	
	# Move rigibody
	if _direction:
		velocity.x = _direction.x * _opponent_config.move_speed
		velocity.z = _direction.z * _opponent_config.move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _opponent_config.move_speed)
		velocity.z = move_toward(velocity.z, 0, _opponent_config.move_speed)

func _jump():
	if is_on_floor():
		velocity.y = _opponent_config.jump_force

func _apply_gravity(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta
