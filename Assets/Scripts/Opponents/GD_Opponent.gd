extends CharacterBody3D
class_name Opponent

#region VARIABLES
@export_category("References")
@export var opponent_config : OpponentConfig
@export var rso_player_position : WrapperVariable

var _direction = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _idle_position : Vector3

var _is_aggroed : bool
var _distance_from_target : float
var _is_attacking : bool
var _custom_timer : float
var _move_funtion_enabled : bool = true
var _look_funtion_enabled : bool = true
var _space_query : PhysicsDirectSpaceState3D
var _query : PhysicsRayQueryParameters3D
var _result : Dictionary
var _sight_enabled : bool = false

@onready var _health_component : HealthComponent = $PF_Health
@onready var _navigation_agent_3d = $NavigationAgent3D
@onready var _debug_head = $"[DEBUG]Head"

signal on_opponent_dies
#endregion


func _ready():
	_health_component.initialize(opponent_config.base_health, opponent_config.health_regeneration, opponent_config.base_armor)
	_health_component.connect("on_health_reached_zero", _die)
	rso_player_position.connect("on_changed", _update_target_position)
	_idle_position = global_transform.origin


func _physics_process(delta):
	_process_movement(delta)
	_space_query = get_viewport().world_3d.direct_space_state


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
	
	_direction = (_navigation_agent_3d.get_next_path_position() - global_position).normalized() * opponent_config.move_speed
	velocity = velocity.move_toward(_direction, 0.25)


func _look_at(target : Vector3):
	if (!_look_funtion_enabled):
		return
	
	if (global_transform.origin.is_equal_approx(target)):
		return
	
	look_at(Vector3(target.x, global_position.y, target.z))


func _jump():
	if is_on_floor():
		velocity.y = opponent_config.jump_force
#endregion


#region AI BEHAVIOUR
func _process_ai_behaviour(delta):
	_handle_sight()
	_handle_aggro()


func _handle_sight():
	if (!_sight_enabled):
		return
	
	var centered_player_position = Vector3(rso_player_position.value.x, rso_player_position.value.y + 1, rso_player_position.value.z)
	
	# Aggro player if within the aggro range
	if ((centered_player_position - _debug_head.global_transform.origin).length() <= opponent_config.aggro_range):
		# Cast a ray3D toward the player position to verify if there is any obstacles
		_result = _space_query.intersect_ray(PhysicsRayQueryParameters3D.create(_debug_head.global_position, centered_player_position))
		if (_result):
			if (_result.collider as Player):
				print("OPPONENT: Player aggroed")
				_is_aggroed = true
	
	# Lose player aggro if out of the aggro range
	if ((centered_player_position - _debug_head.global_transform.origin).length() >= opponent_config.aggro_loss_range):
		print("OPPONENT: Player out of loss aggro range. Go to its last position")
		_unaggro_player()


func _unaggro_player():
	_sight_enabled = false
	await _wait_for(5)
	print("OPPONENT: Player lost. Getting back to idle position")
	_is_aggroed = false
	_navigation_agent_3d.target_position = _idle_position


func _handle_aggro():
	# Exit, if the opponent is already attacking
	if (_is_attacking
		|| !_is_aggroed):
		return
		
	# Get distance from opponent to target
	_distance_from_target = (_navigation_agent_3d.target_position - global_transform.origin).length()
	
	# Exit, if the opponent is out of attack range
	if (_distance_from_target < opponent_config.attack_range.x
		|| _distance_from_target >= opponent_config.attack_range.y):
		return
	
	_start_attack()


func _start_attack():
	_is_attacking = true
	print("OPPONENT: Starting an attack")
	
	# Use melee attack
	if (opponent_config.attack_type == 0): # MELEE
		await _melee_attack()
	
	# Use range attack
	if (opponent_config.attack_type == 1): # RANGE
		await _range_attack()
	
	_is_attacking = false
	_move_funtion_enabled = true
	_look_funtion_enabled = true
	print("OPPONENT: Attack landed")


func _on_ai_sight_area_entered(area):
	if (area.get_parent() as Player):
		_sight_enabled = true


func _on_ai_sight_area_exited(area):
	if (area.get_parent() as Player):
		# TODO - Go to the last player position and look around 
		pass


func _update_target_position():
	if (!_is_aggroed):
		return
	
	_navigation_agent_3d.target_position = rso_player_position.value


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
