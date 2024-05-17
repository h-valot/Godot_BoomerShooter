extends Node
class_name Weapon

@export_category("References")
@export var health_component : HealthComponent

var weapon_config : WeaponConfig
var _initialized : bool = false
var _switching: bool = false
var _muzzle: Node3D

@onready var _head = $"../Head"
@onready var _camera_3d = $"../Head/Camera3D"
@onready var _weapon_inventory = $"/Inventory"


func initialize():
	
	_camera_3d = _camera_3d as Camera3D
	_weapon_inventory = _weapon_inventory as Inventory
	_initialized = true


func set_weapon(new_weapon_config: WeaponConfig):

	if (_switching):
		return

	weapon_config = new_weapon_config
	_bullet_prefab = weapon_config.bullet_mesh

	_switching = true
	await get_tree().create_timer(weapon_config.switch_speed).timeout
	_switching = false


func set_muzzle(muzzle: Node3D):
	_muzzle = muzzle
	print("muzzle set")


func _physics_process(delta):
	
	if (!_initialized):
		return
	
	_space_query = get_viewport().world_3d.direct_space_state


func _process(delta):
	
	_get_inputs()
	_reload(delta)
	_camera_shake(delta)
	_auto_fire(delta)
	_lock_fire(delta)


#region FIRE
var _bullet_prefab: PackedScene
var _space_query: PhysicsDirectSpaceState3D
var _raycast: PhysicsRayQueryParameters3D
var _result: Dictionary
var _firing: bool = false
var _fire_rate_delay: float = 0.0
var _can_fire: bool = true
var _can_fire_delay: float = 0.0


func _get_inputs():

	if (Input.is_action_just_pressed("Fire")):
	
		if (_can_fire
		&& !_is_reloading
		&& !_empty_mag):
	
			_fire()
			_can_fire = false
			_fire_rate_delay = 0
			_firing = true
			
			_successive_shot = 0
			_head.rotate_x(deg_to_rad((weapon_config.recoil_curve.sample(_successive_shot)) * weapon_config.recoil_scalar))
	
	if (Input.is_action_just_released("Fire")):
	
		_firing = false

	if (Input.is_action_just_pressed("Reload")):

		_is_reloading = true;


func _auto_fire(delta):
	
	if (_empty_mag):
		return

	if (_is_reloading):
		return

	if (!_firing):
		return
		
	_fire_rate_delay += delta
	
	if (_fire_rate_delay > weapon_config.fire_rate):

		_fire_rate_delay -= weapon_config.fire_rate
		_fire()


func _lock_fire(delta):
	
	if (_can_fire):
		return
		
	_can_fire_delay += delta
	if (_can_fire_delay > weapon_config.fire_rate):

		_can_fire_delay -= weapon_config.fire_rate
		_can_fire = true


func _fire():

	_use_bullet()
	
	for i in weapon_config.bullet_amount_per_shot:

		if (weapon_config.hit_scan == true): 
			
			_fire_raycast()

		else: 
			
			_fire_bullet()
	
	_recoil()
	

func _fire_raycast():

	var from = _camera_3d.global_position
	var to = _camera_3d.global_position - _camera_3d.global_transform.basis.z * weapon_config.raycast_length

	if (weapon_config.bullet_amount_per_shot > 1):

		to.x += randf_range(weapon_config.spread, -weapon_config.spread)
		to.y += randf_range(weapon_config.spread, -weapon_config.spread)
		to.z += randf_range(weapon_config.spread, -weapon_config.spread)

	_raycast = PhysicsRayQueryParameters3D.create(from, to)
	Gizmo3D.DrawLine(from, to, Color.RED, 1)
	_raycast.collision_mask = 1 # Colliding only with entities
	_raycast.collide_with_areas = true
	_raycast.collide_with_bodies = true
	_result = _space_query.intersect_ray(_raycast)

	if (!_result):
		return;
		
	print("WEAPON: raycast touched: ", _result.collider.name)
	
	if (weapon_config.create_zone_on_impact):
		
		_generate_zone(_result.position)
		return

	if (_result.collider as HitBoxComponent):

		_result.collider.health_component.update_current_health(-weapon_config.bullet_damage)


func _fire_bullet():
	
	var new_bullet = _bullet_prefab.instantiate()
	
	# Parent the bullet outside the player
	# Otherwise, bullets moves with the player
	owner.get_parent().add_child(new_bullet)
	
	var from = _muzzle.global_position
	var to = -_muzzle.global_transform.basis.z.normalized() * 100

	if (weapon_config.bullet_amount_per_shot > 1):
		
		to.x += randf_range(weapon_config.spread, -weapon_config.spread)
		to.y += randf_range(weapon_config.spread, -weapon_config.spread)
		to.z += randf_range(weapon_config.spread, -weapon_config.spread)

	new_bullet = new_bullet as Bullet
	new_bullet.initialize(weapon_config, health_component.receiver_type)
	new_bullet.launch(from, to)


func _generate_zone(impact_position):

	var new_zone = weapon_config.zone_prefab.instantiate()
	owner.get_parent().add_child(new_zone)
	
	new_zone.position = impact_position
	new_zone = new_zone as ImpactZone
	new_zone.initialize(
		weapon_config.zone_radius, 
		weapon_config.zone_lifetime, 
		weapon_config.zone_damage_per_tick, 
		weapon_config.zone_tick_duration, 
		health_component.receiver_type
	)

#endregion


#region RELOAD
var _empty_mag: bool = false;
var _is_reloading : bool = false
var _reload_delay : float = 0.0


func _reload(delta):

	if (!_is_reloading):
		return
	
	_reload_delay += delta
	
	if (_reload_delay > weapon_config.reload_time):

		_reload_delay -= weapon_config.reload_time

		# Reloading functionality
		var new_stored_bullet_amount: int = weapon_config.stored_bullet_amount - weapon_config.mag_size
		var new_current_bullet_amount: int

		if (new_stored_bullet_amount == -weapon_config.mag_size):

			_empty_mag = true;
			_is_reloading = false;
			return
		
		if (new_stored_bullet_amount >= 0):

			new_current_bullet_amount = weapon_config.mag_size

		else:

			new_current_bullet_amount = weapon_config.mag_size + new_stored_bullet_amount
		
		weapon_config.stored_bullet_amount -= new_current_bullet_amount
		weapon_config.current_bullet_amount = new_current_bullet_amount

		_is_reloading = false;


func _use_bullet():

	weapon_config.current_bullet_amount -= 1

	if (weapon_config.current_bullet_amount <= 0):

		_is_reloading = true
		return;

#endregion


#region RECOIL
var _shake_strength : float = 0.0
var _rnd = RandomNumberGenerator.new()
var _successive_shot : int = 0


func _recoil():

	_successive_shot += 1
	_head.rotate_x(deg_to_rad((weapon_config.recoil_curve.sample(_successive_shot)) * weapon_config.recoil_scalar))
	_shake_strength = weapon_config.camera_shake_strength


func _camera_shake(delta):

	if (_shake_strength <= 0):
		return
	
	_shake_strength = lerpf(_shake_strength, 0, weapon_config.camera_shake_fade * delta)
	_camera_3d.h_offset = _rnd.randf_range(-_shake_strength, _shake_strength)

#endregion
