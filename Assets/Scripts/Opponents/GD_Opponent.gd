extends CharacterBody3D
class_name Opponent

#region VARIABLES
@export_category("References")
@export var opponent_config : OpponentConfig
@export var rso_player_position : WrapperVariable

var _direction = Vector3.ZERO
var _idle_position : Vector3
var _move_funtion_enabled : bool = true
var _look_funtion_enabled : bool = true

var _distance_from_target : float
var _space_query : PhysicsDirectSpaceState3D
var _result : Dictionary
var _centered_player_position : Vector3
var _sight_enabled : bool
var _is_aggroed : bool
var _is_attacking : bool

var _custom_timer : float
var _is_alive : bool = true

@onready var _health_component : HealthComponent = $PF_Health
@onready var _navigation_agent_3d = $NavigationAgent3D
@onready var _capsule_collision = $CapsuleCollision
@onready var _flight_offset = $FlightOffset
@onready var _debug_head = $"FlightOffset/[DEBUG]Head"

signal on_opponent_dies
#endregion


func _ready():

	_health_component.initialize(opponent_config.base_health, opponent_config.health_regeneration, opponent_config.base_armor)
	_health_component.connect("on_health_reached_zero", _die)
	rso_player_position.connect("on_changed", _update_target_position)
	_health_component.connect("on_health_changed", _getting_touched)
	_health_component.connect("on_armor_changed", _getting_touched)
	_idle_position = global_transform.origin
	
	# Initialize flying opponents
	if (opponent_config.flight_height > 0):

		_capsule_collision.set_deferred("disabled", true) 
		_flight_offset.global_position = Vector3(global_position.x, global_position.y + opponent_config.flight_height + opponent_config.flight_height * 0.25, global_position.z) 
		_navigation_agent_3d.set_navigation_layer_value(1, false)
		_navigation_agent_3d.set_navigation_layer_value(2, true)
	
	else:

		_navigation_agent_3d.set_navigation_layer_value(1, true)
		_navigation_agent_3d.set_navigation_layer_value(2, false)


func _physics_process(delta):

	_process_movement(delta)
	_space_query = get_viewport().world_3d.direct_space_state


func _process(delta):

	_process_ai_behaviour(delta)


func _die():

	_is_alive = false
	on_opponent_dies.emit()
	self.queue_free()


#region MOVEMENT
var debug_timer : float = 0
func _process_movement(delta):

	if (debug_timer < 1):

		debug_timer += delta
		return
	
	_apply_gravity(delta)
	_move()
	_look_at(_navigation_agent_3d.get_next_path_position())
	move_and_slide()


func _apply_gravity(delta):

	if is_on_floor():
		return

	if (opponent_config.flight_height > 0
	&& _is_alive):
		return

	velocity.y -= opponent_config.gravity * delta


func _move():

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
var _process_ai_behaviour_timer : float
func _process_ai_behaviour(delta):
	
	# Custom clock to optimize perfomances
	_process_ai_behaviour_timer += delta
	if (_process_ai_behaviour_timer < 0.1):
		return
	_process_ai_behaviour_timer -= 0.1

	# Get distance from opponent to target
	_distance_from_target = (_navigation_agent_3d.target_position - global_transform.origin).length()
	
	_handle_sight()
	_handle_aggro()


func _handle_sight():

	if (!_sight_enabled):
		return
	
	_check_target_in_sight()
	_check_target_out_of_sight()


func _check_target_in_sight():

	if (_is_aggroed):
		return

	if (_distance_from_target > opponent_config.aggro_range):
		return
	
	_centered_player_position =  Vector3(rso_player_position.value.x, rso_player_position.value.y + 1.5, rso_player_position.value.z)

	# Cast a ray3D toward the player position to verify if there is any obstacles
	_result = _space_query.intersect_ray(PhysicsRayQueryParameters3D.create(_debug_head.global_position, _centered_player_position))
	if (_result):
		
		if (_result.collider as Player):
			
			_getting_touched()
	

func _check_target_out_of_sight():

	if (!_is_aggroed):
		return
	
	if (_distance_from_target >= opponent_config.loss_distance_from_idle):

		_is_aggroed = false
		_sight_enabled = false

		# Getting back to the idle position
		print("OPPONENT: Target lelf the max aggro distance. Getting back to idle position.")
		_navigation_agent_3d.target_position = _idle_position


func _getting_touched():

	if (!_is_aggroed):

		_is_aggroed = true
		print("OPPONENT: Target aggroed")

	_handle_interruption()


func _handle_aggro():

	# Exit, if the opponent is already attacking
	if (_is_attacking
		|| !_is_aggroed):
		return
		
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
	
	if (_interrupted):
		return;

	_is_attacking = false
	_move_funtion_enabled = true
	_look_funtion_enabled = true
	print("OPPONENT: Attack landed")


func _on_ai_sight_area_entered(area):

	if (area.get_parent() as Player):

		if (_sight_enabled):
			return
		
		print("OPPONENT: Sight functions (re)activated")
		_sight_enabled = true


func _on_ai_sight_area_exited(area):

	if (area.get_parent() as Player):

		# Do nothing
		pass


func _update_target_position():

	if (!_is_aggroed):
		return
	
	_navigation_agent_3d.target_position = rso_player_position.value


func _handle_interruption():

	if (!_interruptable):
		return

	if (_interrupted):
		return

	print("OPPONENT: Attack interrupted ")
	_interrupted = true;
	_move_funtion_enabled = false
	_look_funtion_enabled = false
	await _wait_for(opponent_config.interrupt_revorery_time)
	_move_funtion_enabled = true
	_look_funtion_enabled = true
	_interrupted = false;


var _interrupted : bool = false
var _interruptable : bool = false
func _wait_for(delay : float, with_interruption : bool = false):

	_custom_timer = delay
	while _custom_timer > 0:

		if (with_interruption &&
		opponent_config.can_be_interrupted):

			_interruptable = true
		
		await get_tree().create_timer(0.1).timeout
		_custom_timer -= 0.1
	
	_interruptable = false


#region MELEE ATTACK
func _melee_attack():

	await _charge_and_pursue()

	if (_interrupted):
		return;

	await _lock_position()

	if (_interrupted):
		return;

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
	
	# TODO - Wait till the end of the attack animation with a signal
	
	# TODO - Disable melee damage collision area
	
	# Wait for the recovery time
	await _wait_for(opponent_config.attack_recovery_time)
#endregion


#region RANGE ATTACK
func _range_attack():

	await _charge_and_aim()

	if (_interrupted):
		return;

	await _lock_and_finish_charge()

	if (_interrupted):
		return;

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

	# Fire a bullet toward the opponent "looking at" diretion
	_fire_bullet()
	
	# Wait for the recovery time
	await _wait_for(opponent_config.attack_recovery_time)


func _fire_bullet():
	
	var new_bullet = opponent_config.weapon_used._bullet_prefab.instantiate()
	
	# Parent the bullet outside the player
	# Otherwise, bullets moves with the player
	owner.get_parent().add_child(new_bullet)
	
	new_bullet.transform = _debug_head.global_transform
	new_bullet = new_bullet as Bullet
	new_bullet.initialize(opponent_config.weapon_used, opponent_config.weapon_used.zone_prefab, _health_component.receiver_type)
#endregion
#endregion
