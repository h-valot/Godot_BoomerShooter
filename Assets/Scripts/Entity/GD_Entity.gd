extends CharacterBody3D
class_name Entity

#region VARIABLES
@export_category("References")
@export var entity_config : EntityConfig

@export_group("Forbidden")
@export var rso_player_position : RuntimeScriptableObject
@export var rse_display_dialogue: RuntimeScriptableEventT1
@export var rse_entity_killed: RuntimeScriptableEventT0

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
@onready var _attack_point = $"FlightOffset/AttackPoint"
@onready var _interactable: Interactable = $"Interactable"

signal on_entity_dies
#endregion


func _ready():

	_health_component.initialize(entity_config.base_health, entity_config.health_regeneration, entity_config.base_armor)
	_health_component.set_immunity(entity_config.damage_immunity)
	_health_component.on_health_reached_zero.connect(_die)
	rso_player_position.on_changed.connect(_update_target_position)
	_health_component.on_health_changed.connect(_getting_touched)
	_health_component.on_armor_changed.connect(_getting_touched)
	_interactable.on_interact.connect(_on_next_dialogue)
	_idle_position = global_transform.origin
	
	# Initialize flying opponents
	if (entity_config.flight_height > 0):

		_capsule_collision.set_deferred("disabled", true) 
		_flight_offset.global_position = Vector3(global_position.x, global_position.y + entity_config.flight_height + entity_config.flight_height * 0.25, global_position.z) 
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

	rse_entity_killed.trigger()
	_is_alive = false
	on_entity_dies.emit()
	self.queue_free()


#region DIALOGUE

func _on_next_dialogue(_other: Node):

	if (!entity_config.dialogue):
		return

	rse_display_dialogue.trigger(entity_config.dialogue)

#endregion


#region MOVEMENT

var debug_timer : float = 0


func _process_movement(delta):

	if (!entity_config.can_move):
		return

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

	if (entity_config.flight_height > 0
	&& _is_alive):
		return

	velocity.y -= entity_config.gravity * delta


func _move():

	if (!_move_funtion_enabled):

		velocity = Vector3(0, 0, 0)
		return		

	_direction = (_navigation_agent_3d.get_next_path_position() - global_position).normalized() * entity_config.move_speed
	velocity = velocity.move_toward(_direction, 0.25)


func _look_at(target : Vector3):

	if (!_look_funtion_enabled):
		return

	if (global_transform.origin.is_equal_approx(target)):
		return
	
	look_at(Vector3(target.x, global_position.y, target.z))


func _jump():

	if is_on_floor():

		velocity.y = entity_config.jump_force

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
	_distance_from_target = (rso_player_position.value - global_transform.origin).length()
	
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

	if (_distance_from_target > entity_config.aggro_range):
		return
	
	_centered_player_position =  Vector3(rso_player_position.value.x, rso_player_position.value.y + 1.5, rso_player_position.value.z)

	# Cast a ray3D toward the player position to verify if there is any obstacles
	_result = _space_query.intersect_ray(PhysicsRayQueryParameters3D.create(_attack_point.global_position, _centered_player_position))
	if (_result):
		
		if (_result.collider as Character):
			
			if (!_is_aggroed):

				_is_aggroed = true
				print("OPPONENT: Target aggroed")
	

func _check_target_out_of_sight():

	if (!_is_aggroed):
		return
	
	if (_distance_from_target >= entity_config.loss_distance_from_idle):

		_is_aggroed = false
		_sight_enabled = false

		# Getting back to the idle position
		print("OPPONENT: Target lelf the max aggro distance. Getting back to idle position.")
		_navigation_agent_3d.target_position = _idle_position


func _getting_touched(_new_amount: int = 0, delta: int = 0):

	# Ignore healing
	if (delta >= 0):
		return

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
	if (_distance_from_target < entity_config.attack_range.x
		|| _distance_from_target >= entity_config.attack_range.y):
		return
	
	_start_attack()


func _start_attack():
	_is_attacking = true
	print("OPPONENT: Starting an attack")
	
	await _handle_attack()
	
	if (_interrupted):
		return;

	_is_attacking = false
	_move_funtion_enabled = true
	_look_funtion_enabled = true
	print("OPPONENT: Attack landed")


func _on_ai_sight_area_entered(area):

	var player: Character = area.get_parent() as Character
	if (player != null):
		if (!player.player_config.is_invisible):

			if (_sight_enabled):
				return
			
			print("OPPONENT: Sight functions (re)activated")
			_sight_enabled = true
		elif(player.player_config.is_invisible):
			_sight_enabled = false


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
	_interrupted = true
	_move_funtion_enabled = false
	_look_funtion_enabled = false
	await _wait_for(entity_config.interrupt_recovery_time)
	print("OPPONENT: Interrupt recovery delay passed")
	_interrupted = false
	_is_attacking = false
	_move_funtion_enabled = true
	_look_funtion_enabled = true


var _interrupted : bool = false
var _interruptable : bool = false
func _wait_for(delay : float, with_interruption : bool = false):

	_custom_timer = delay
	while _custom_timer > 0:

		if (with_interruption &&
		entity_config.can_be_interrupted):

			_interruptable = true

			if (_interrupted):

				_interruptable = false
				return
		
		await get_tree().create_timer(0.1).timeout
		_custom_timer -= 0.1
		
	
	_interruptable = false



#region ATTACK


func _handle_attack():

	await _charge_and_aim()

	if (_interrupted):
		return;

	await _lock_target()

	if (_interrupted):
		return;

	await _attack()


func _charge_and_aim():

	# Lock movement
	_move_funtion_enabled = false
	
	# Wait for first charge time with interruption enabled
	await _wait_for(entity_config.first_charge_time, true)


func _lock_target():

	# Lock rotation
	_look_funtion_enabled = false
	
	# Wait for first charge time with interruption enabled
	await _wait_for(entity_config.final_charge_time, true)


func _attack():

	# Fire a bullet toward the opponent "looking at" diretion
	_fire_bullet()
	
	# Wait for the recovery time
	await _wait_for(entity_config.attack_recovery_time)


func _fire_bullet():
	
	var new_bullet = entity_config.weapon_used.bullet_mesh.instantiate()
	owner.get_parent().add_child(new_bullet)
	
	new_bullet.transform = _attack_point.global_transform
	new_bullet = new_bullet as Bullet
	new_bullet.initialize(entity_config.weapon_used, _health_component.receiver_type)

	var from = _attack_point.global_position
	var to = -_attack_point.global_transform.basis.z.normalized() * 100
	new_bullet.launch(from, to)

#endregion

#endregion
