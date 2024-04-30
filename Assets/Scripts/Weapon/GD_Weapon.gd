extends Node
class_name Weapon

@export_category("References")
@export var health_component : HealthComponent
@export var zone_prefab : PackedScene

var _firing : bool = false
var _fire_rate_delay : float = 0.0

var _can_fire : bool = true
var _can_fire_delay : float = 0.0

var _space_query : PhysicsDirectSpaceState3D
var _raycast : PhysicsRayQueryParameters3D
var _result : Dictionary
var _weapon_config : WeaponConfig
var _bullet_prefab : PackedScene
var _initialized : bool = false

@onready var _muzzle = $"../Head/Camera3D/CSGBox3D/Muzzle"
@onready var _camera_3d = $"../Head/Camera3D"


func initialize(bullet_prefab : PackedScene, weapon_config : WeaponConfig):
	
	_bullet_prefab = bullet_prefab
	_weapon_config = weapon_config
	_initialized = true


func _physics_process(delta):
	
	if (!_initialized):
		return
	
	_space_query = get_viewport().world_3d.direct_space_state


func _process(delta):
	
	_get_inputs()
	_auto_fire(delta)
	_lock_fire(delta)


## Handle weapon fire input
func _get_inputs():

	if (Input.is_action_just_pressed("Fire")):
	
		if (_can_fire):
	
			_fire()
			_can_fire = false
			_fire_rate_delay = 0
			_firing = true
	
	if(Input.is_action_just_released("Fire")):
	
		_firing = false


func _auto_fire(delta):
	
	if (!_firing):
		return
		
	_fire_rate_delay += delta
	
	if (_fire_rate_delay > _weapon_config.fire_rate):

		_fire_rate_delay -= _weapon_config.fire_rate
		_fire()


func _lock_fire(delta):
	
	if (_can_fire):
		return
		
	_can_fire_delay += delta
	if (_can_fire_delay > _weapon_config.fire_rate):

		_can_fire_delay -= _weapon_config.fire_rate
		_can_fire = true


func _fire():
	
	for i in _weapon_config.bullet_amount_per_shot:

		if (_weapon_config.hit_scan == true): 
			
			_fire_raycast()

		else: 
			
			_fire_bullet()


func _fire_raycast():

	var from = _camera_3d.global_position
	var to = _camera_3d.global_position - _camera_3d.global_transform.basis.z * 100

	if (_weapon_config.bullet_amount_per_shot > 1):

		to.x += randf_range(_weapon_config.spread, -_weapon_config.spread)
		to.y += randf_range(_weapon_config.spread, -_weapon_config.spread)
		to.z += randf_range(_weapon_config.spread, -_weapon_config.spread)

	_raycast = PhysicsRayQueryParameters3D.create(from, to)
	Gizmo3D.DrawLine(from, to, Color.RED, 1)
	_raycast.collision_mask = 1 # Colliding only with entities
	_raycast.collide_with_areas = true
	_raycast.collide_with_bodies = _weapon_config.create_zone_on_impact
	_result = _space_query.intersect_ray(_raycast)

	if (!_result):
		return;
		
	print("WEAPON: raycast touched: ", _result.collider.name)
	
	if (_weapon_config.create_zone_on_impact):
		
		_generate_zone(_result.position)
		return

	if (_result.collider as HitBoxComponent):

		_result.collider.health_component.update_current_health(-_weapon_config.bullet_damage)


func _fire_bullet():
	
	var new_bullet = _bullet_prefab.instantiate()
	
	# Parent the bullet outside the player
	# Otherwise, bullets moves with the player
	owner.get_parent().add_child(new_bullet)
	
	var from = _muzzle.global_position
	var to = -_muzzle.global_transform.basis.z.normalized() * 100

	if (_weapon_config.bullet_amount_per_shot > 1):
		
		to.x += randf_range(_weapon_config.spread, -_weapon_config.spread)
		to.y += randf_range(_weapon_config.spread, -_weapon_config.spread)
		to.z += randf_range(_weapon_config.spread, -_weapon_config.spread)

	new_bullet = new_bullet as Bullet
	new_bullet.initialize(_weapon_config, zone_prefab, health_component.receiver_type)
	new_bullet.launch(from, to)


func _generate_zone(impact_position):

	var new_zone = zone_prefab.instantiate()
	owner.get_parent().add_child(new_zone)
	
	new_zone.position = impact_position
	new_zone.initialize(
		_weapon_config.zone_radius, 
		_weapon_config.zone_lifetime, 
		_weapon_config.zone_damage_per_tick, 
		_weapon_config.zone_tick_duration, 
		health_component.receiver_type
	)
