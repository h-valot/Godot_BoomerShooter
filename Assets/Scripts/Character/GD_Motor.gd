extends CharacterBody3D
class_name Motor

@export_group("Main properties")
@export var max_health_points : float = 100
@export var health_regeneration : float = 5
@export var armor : float = 50

@export_group("Movement properties")
@export_subgroup("Movement speed settings")
@export var base_movement_speed : float = 10
@export var sprint_movement_speed : float = 12.5
@export_range(0, 1) var air_control_scalar : float = 1
@export var movement_speed_acceleration : float = 10
@export_subgroup("Mouse settings")
@export var horizontal_mouse_sensitivity : float = 0.4
@export var vertical_mouse_sensitivity : float = 0.2
@export var max_vertical_aim : float = 89
@export_subgroup("Jump settings")
@export var jump_force : float = 4.5
@export_multiline var gravity_hint : String = "You can tweak the gravity value (9.8) in the project settings > physics > 3d > default gravity"

@export_group("Combat properties")
@export var i_frame_duration : float = 0.5 
@export var consumable_switch_time : float = 0.25

var _current_movement_speed = base_movement_speed;
var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _head = $Head

func _ready():
	# Hide cursor in-game
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	_look(event)

func _physics_process(delta):
	
	_apply_gravity(delta)
	
	# Handle player inputs
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
		_direction = lerp(_direction, _new_direction, air_control_scalar)
	else:
		_direction = lerp(_direction, _new_direction, delta * movement_speed_acceleration)
	
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
		_current_movement_speed = sprint_movement_speed
	else:
		_current_movement_speed = base_movement_speed

func _jump():
	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force

func _apply_gravity(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta

func _look(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * horizontal_mouse_sensitivity))
		_head.rotate_x(deg_to_rad(-event.relative.y * vertical_mouse_sensitivity))
		_head.rotation.x = clamp(_head.rotation.x, deg_to_rad(-max_vertical_aim), deg_to_rad(max_vertical_aim))
