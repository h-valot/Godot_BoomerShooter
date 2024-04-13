extends CharacterBody3D
class_name Player

@export_category("References")
@export var player_config : PlayerConfig
@export var bullet_prefab : PackedScene
@export var weapon_config : WeaponConfig

var _current_movement_speed : float
var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _weapon = $Weapon
@onready var _head = $Head

func _ready():
	_weapon.initialize(bullet_prefab, weapon_config)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#region MOTOR
func _input(event):
	_look(event)

func _physics_process(delta):	
	_apply_gravity(delta)
	_jump()
	_sprint()
	_move(delta)
	move_and_slide()

func _move(delta):
	# Get the input direction and handle the movement/deceleration
	var _new_input = Input.get_vector("Left", "Right", "Forward", "Backward")
	var _new_direction = (transform.basis * Vector3(_new_input.x, 0, _new_input.y)).normalized()
	
	# Handle air-control
	if not is_on_floor():
		_direction = lerp(_direction, _new_direction, player_config.air_control_scalar)
	else:
		_direction = lerp(_direction, _new_direction, delta * player_config.move_speed_acceleration)
	
	# Move rigibody
	if _direction:
		velocity.x = _direction.x * _current_movement_speed
		velocity.z = _direction.z * _current_movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _current_movement_speed)
		velocity.z = move_toward(velocity.z, 0, _current_movement_speed)

func _sprint():
	# Handle sprint
	if Input.is_action_just_pressed("Sprint") and is_on_floor():
		_current_movement_speed = player_config.sprint_move_speed
	else:
		_current_movement_speed = player_config.base_move_speed

func _jump():
	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = player_config.jump_force

func _apply_gravity(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta

func _look(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * player_config.horizontal_mouse_sensitivity))
		_head.rotate_x(deg_to_rad(-event.relative.y * player_config.vertical_mouse_sensitivity))
		_head.rotation.x = clamp(_head.rotation.x, deg_to_rad(-player_config.max_vertical_aim), deg_to_rad(player_config.max_vertical_aim))
#endregion
