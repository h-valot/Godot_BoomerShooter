extends CharacterBody3D
class_name Character

@export_category("Character")
@export var player_config : CharacterConfig
@export var weapon_config : WeaponConfig

@export_group("Forbidden")
@export var rso_player_position : RuntimeScriptableObject
@export var rso_player_interactable: RuntimeScriptableObject
@export var rse_player_died: RuntimeScriptableEventT0
@export var rse_kill_player: RuntimeScriptableEventT0

var _current_movement_speed : float
var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _weapon: Weapon = $Weapon
@onready var _head = $Head
@onready var _health_component = $PF_Health
@onready var _hud = $PF_PlayerHud
@onready var _camera_3d = $"Head/Camera3D"
@onready var _interactable: Interactable = $"Head/Interactable"


func _ready():

	_hud.initialize(player_config)
	_health_component.on_health_changed.connect(_hud.update_health_bar)
	rse_kill_player.action.connect(_handle_death)
	_health_component.on_health_reached_zero.connect(_handle_death)
	_health_component.on_armor_changed.connect(_hud.update_armor_bar)
	_health_component.initialize(
		player_config.base_health, 
		player_config.health_regeneration,
		player_config.base_armor,
		player_config.iframe_duration
	)

	rso_player_interactable.value = _interactable
	_weapon.initialize()
	weapon_config.initialize_mag()
	_weapon.set_weapon(weapon_config)
	_current_weapon_index = _weapon_inventory.get_index_by_item(weapon_config)
	_instantiate_weapon()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):	

	_handle_move(delta)
	_change_weapon()


func _handle_death():
	
	print("player killed")
	rse_player_died.trigger()


#region MOTOR
func _input(event):

	_look(event)


func _handle_move(delta):

	_apply_gravity(delta)
	_jump()
	_sprint()
	_move(delta)
	move_and_slide()
	rso_player_position.value = global_transform.origin


func _move(delta):

	# Get the input direction and handle the movement/deceleration
	var _new_input: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	var _new_direction: Vector3 = (transform.basis * Vector3(_new_input.x, 0, _new_input.y)).normalized()
	
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
	if (Input.is_action_just_pressed("Sprint")
	&& is_on_floor()):

		_current_movement_speed = player_config.sprint_move_speed

	else:

		_current_movement_speed = player_config.base_move_speed


func _jump():

	# Handle jump
	if (Input.is_action_just_pressed("Jump")
	&& is_on_floor()):

		velocity.y = player_config.jump_force



func _apply_gravity(delta):

	# Add the gravity
	if (!is_on_floor()):

		velocity.y -= _gravity * delta


func _look(event):

	if (event is InputEventMouseMotion):

		rotate_y(deg_to_rad(-event.relative.x * player_config.horizontal_mouse_sensitivity))
		_head.rotate_x(deg_to_rad(-event.relative.y * player_config.vertical_mouse_sensitivity))
		_head.rotation.x = clamp(_head.rotation.x, deg_to_rad(-player_config.max_vertical_aim), deg_to_rad(player_config.max_vertical_aim))
#endregion


#region WEAPON
var _current_weapon_index: int = 0
var _current_weapon_prefab: WeaponPrefab = null

@onready var _weapon_inventory : Inventory = $WeaponInventory


func _change_weapon():

	if (Input.is_action_just_pressed("Weapon-1")):
		_set_weapon(0)

	if (Input.is_action_just_pressed("Weapon-2")):
		_set_weapon(1)

	if (Input.is_action_just_pressed("Weapon-3")):
		_set_weapon(2)

	if (Input.is_action_just_pressed("Weapon-4")):
		_set_weapon(3)

	if (Input.is_action_just_pressed("Weapon-5")):
		_set_weapon(4)

	if (Input.is_action_just_pressed("Weapon-6")):
		_set_weapon(5)

	if (Input.is_action_just_pressed("Weapon-7")):
		_set_weapon(6)

	if (Input.is_action_just_pressed("Weapon-8")):
		_set_weapon(7)

	if (Input.is_action_just_pressed("Weapon-9")):
		_set_weapon(8)

	if (Input.is_action_just_pressed("Weapon-0")):
		_set_weapon(9)

	if (Input.is_action_just_pressed("Scroll-up")):
		_cycle_weapon(1)

	if (Input.is_action_just_pressed("Scroll-down")):
		_cycle_weapon(-1)


func _cycle_weapon(direction: int):

	var index: int = _current_weapon_index + direction

	if (index < 0):
		index = _weapon_inventory.get_length()

	if (index >= _weapon_inventory.get_length()):
		index = 0
	
	_set_weapon(index)


func _set_weapon(index: int):

	var weapon_at_index: WeaponConfig = _weapon_inventory.get_item_by_index((index))

	if (weapon_at_index == null || !_weapon_inventory.have_item(weapon_at_index)):
		return;

	_weapon.set_weapon(weapon_at_index)
	_current_weapon_index = index
	_instantiate_weapon()


func _instantiate_weapon():

	if (_current_weapon_prefab):

		_current_weapon_prefab.queue_free()

	_current_weapon_prefab = _weapon.weapon_config.item_mesh.instantiate()
	_camera_3d.add_child(_current_weapon_prefab)

	_weapon.set_muzzle(_current_weapon_prefab.muzzle)

#endregion
