extends Node
class_name Weapon

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
	
	if (_weapon_config.hit_scan == true):
	
		_fire_raycast()
	
	else:
	
		_fire_bullet()


func _fire_raycast():
	
	_raycast = PhysicsRayQueryParameters3D.create(_camera_3d.global_position, _camera_3d.global_position - _camera_3d.global_transform.basis.z * 100)
	_raycast.collide_with_areas = true
	_raycast.collide_with_bodies = false
	_result = _space_query.intersect_ray(_raycast)

	if (_result):
		
		print("WEAPON: raycast touched: ", _result.collider.name)
		
		if (_result.collider as HitBoxComponent):

			_result.collider.health_component.update_current_health(-_weapon_config.bullet_damage)


func _fire_bullet():
	
	var new_bullet = _bullet_prefab.instantiate()
	
	# Parent the bullet outside the player
	# Otherwise, bullets moves with the player
	owner.get_parent().add_child(new_bullet)
	
	new_bullet.transform = _muzzle.global_transform
	new_bullet = new_bullet as Bullet
	new_bullet.initialize(_weapon_config)
