extends Node
class_name Fire

@export_group("References")
@export var _bullet_prefab : PackedScene
@export var debug_weapon_config : WeaponConfig

var _fire_rate_delay : float = 0.0
var _firing : bool = false
var _can_fire_delay : float = 0.0
var _can_fire : bool = true
var _space_query
var _weapon_config : WeaponConfig

@onready var _muzzle = $"../Motor/Head/Camera3D/CSGBox3D/Muzzle"
@onready var _camera_3d = $"../Motor/Head/Camera3D"

func _physics_process(delta):
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
	if (_fire_rate_delay > debug_weapon_config.fire_rate):
		_fire_rate_delay -= debug_weapon_config.fire_rate
		_fire()

func _lock_fire(delta):
	if (_can_fire):
		return
		
	_can_fire_delay += delta
	if (_can_fire_delay > debug_weapon_config.fire_rate):
		_can_fire_delay -= debug_weapon_config.fire_rate
		_can_fire = true

func _fire():
	if (debug_weapon_config.hit_scan == true):
		_fire_raycast()
	else:
		_fire_bullet()

func _fire_raycast():
	var query = PhysicsRayQueryParameters3D.create(_camera_3d.global_position, _camera_3d.global_position - _camera_3d.global_transform.basis.z * 100)
	var result  = _space_query.intersect_ray(query)
	if result:
		print("WEAPON: reycast touched: ", result.collider.name)

func _fire_bullet():
	var new_bullet = _bullet_prefab.instantiate()
	owner.add_child(new_bullet)
	new_bullet.transform = _muzzle.global_transform
	new_bullet = new_bullet as Bullet
	new_bullet.initialize(debug_weapon_config)
