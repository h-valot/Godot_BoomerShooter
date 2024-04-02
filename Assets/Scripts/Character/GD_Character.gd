extends CharacterBody3D

@export_group("Main properties")
@export var health_points : float = 100
@export var health_regeneration : float = 5
@export var armor : float = 50
@export var stamina : float = 100

@export_group("Movement properties")
@export_subgroup("Movement speed settings")
@export var base_movement_speed : float = 10
@export var sprint_movement_speed : float = 12.5
@export var movement_speed_acceleration : float = 10
@export_subgroup("Mouse settings")
@export var horizontal_mouse_sensitivity : float = 0.4
@export var vertical_mouse_sensitivity : float = 0.2
@export_subgroup("Jump settings")
@export var jump_force : float = 4.5
@export var gravity : float = 9.8

@export_group("Combat properties")
@export var i_frame_duration : float = 0.5 
@export var consumable_switch_time : float = 0.25

@onready var _head = $Head
var _current_movement_speed = base_movement_speed;
var _direction = Vector3.ZERO

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
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	_direction = lerp(_direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * movement_speed_acceleration)
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
		velocity.y -= gravity * delta

func _look(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * horizontal_mouse_sensitivity))
		_head.rotate_x(deg_to_rad(-event.relative.y * vertical_mouse_sensitivity))
		_head.rotation.x = clamp(_head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
