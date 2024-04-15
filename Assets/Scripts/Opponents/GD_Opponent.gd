extends CharacterBody3D
class_name Opponent

#region VARIABLES
@export_category("References")
@export var opponent_config : OpponentConfig
@export var rso_player_position : WrapperVariable

var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _idle_position : Vector3

@onready var _health_component : HealthComponent = $PF_Health
@onready var _navigation_agent_3d = $NavigationAgent3D

signal on_opponent_dies
#endregion

func _ready():
	_health_component.initialize(opponent_config.base_health, opponent_config.health_regeneration, opponent_config.base_armor)
	_health_component.connect("on_health_reached_zero", _die)
	rso_player_position.connect("on_changed", _update_target_position)
	_idle_position = global_transform.origin

func _physics_process(delta):
	_process_movement(delta)

func _process(delta):
	_process_ai_behaviour(delta)

func _die():
	emit_signal("on_opponent_dies")
	self.queue_free()

#region MOVEMENT
var debug_timer : float = 0
func _process_movement(delta):
	if (debug_timer < 1):
		debug_timer += delta
		return
	
	_apply_gravity(delta)
	_move(delta)
	_look_at(_navigation_agent_3d.target_position)
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta

func _move(delta):
	if (!_move_funtion_enabled):
		velocity = Vector3(0, 0, 0)
		return
	
	_direction = (_navigation_agent_3d.get_next_path_position() - global_transform.origin).normalized() * opponent_config.move_speed
	velocity = velocity.move_toward(_direction, 0.25)

func _update_target_position():
	_navigation_agent_3d.target_position = rso_player_position.value

func _look_at(target : Vector3):
	if (!_look_funtion_enabled):
		return
	
	look_at(Vector3(target.x, global_transform.origin.y, target.z))

func _jump():
	if is_on_floor():
		velocity.y = opponent_config.jump_force
#endregion

#region AI BEHAVIOUR
var _distance_from_target : float
var _is_attacking : bool
var _custom_timer : float
var _move_funtion_enabled : bool = true
var _look_funtion_enabled : bool = true

func _process_ai_behaviour(delta):
	# Get distance from opponent to target
	_distance_from_target = (_navigation_agent_3d.target_position - global_transform.origin).length()
	
	# Exit, if the opponent is already attacking
	if (_is_attacking):
		return
	
	# Exit, if the opponent is out of attack range
	if (_distance_from_target < opponent_config.attack_range.x
		|| _distance_from_target >= opponent_config.attack_range.y):
		return
	
	_start_attack()

func _start_attack():
	_is_attacking = true
	
	# Use melee attack
	if (opponent_config.attack_type == 0): # MELEE
		await _melee_attack()
	
	# Use range attack
	if (opponent_config.attack_type == 1): # RANGE
		await _range_attack()
	
	_is_attacking = false
	_move_funtion_enabled = true
	_look_funtion_enabled = true

func _wait_for(delay : float, with_interruption : bool = false):
	_custom_timer = delay
	while _custom_timer > 0:
		await get_tree().create_timer(0.1).timeout
		_custom_timer -= 0.1
		
		if (with_interruption):
			# TODO - Handle interruption
			pass

#region MELEE ATTACK
func _melee_attack():
	await _charge_and_pursue()
	await _lock_position()
	await _slach()

func _charge_and_pursue():
	# TODO - Play charge animation
	
	# Wait for first charge delay with interruption enabled
	await _wait_for(opponent_config.first_charge_time, true)

func _lock_position():
	# Lock movement
	_move_funtion_enabled = false
	
	# Wait for final charge delay with interruption enabled
	await _wait_for(opponent_config.final_charge_time, true)

func _slach():
	# Lock rotation
	_look_funtion_enabled = false
	
	# TODO - Enable melee damage collision area
	
	# TODO - Wait till the end of the attack animation or a timer
	
	# TODO - Disable melee damage collision area
	
	# Wait for the recovery time
	await _wait_for(opponent_config.attack_recovery_time)
#endregion
#region RANGE ATTACK
func _range_attack():
	await _charge_and_aim()
	await _lock_and_finish_charge()
	await _shoot()

func _charge_and_aim():
	# Lock movement
	_move_funtion_enabled = false
	
	# Wait for first charge time with interruption enabled
	await _wait_for(opponent_config.first_charge_time, true)

func _lock_and_finish_charge():
	# Lock rotation
	_look_funtion_enabled = false
	
	# Wait for first charge time with interruption enabled
	await _wait_for(opponent_config.final_charge_time, true)

func _shoot():
	# TODO - Fire a bullet toward the opponent "looking at" diretion
	
	# Wait for the recovery time
	await _wait_for(opponent_config.attack_recovery_time)
#endregion
#endregion
