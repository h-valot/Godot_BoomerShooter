extends Node
class_name Weapon

@export_group("References")
@export var _bullet_prefab : PackedScene

var _space_query
var _weapon_config : WeaponConfig
@onready var _muzzle = $CSGBox3D/Muzzle
@onready var _camera_3d = $"../Camera3D"

func _physics_process(delta):
	_space_query = get_viewport().world_3d.direct_space_state

func fire(weapon_config : WeaponConfig):
	# Update weapon config
	if (_weapon_config != weapon_config):
		_weapon_config = weapon_config
	
	if (_weapon_config.hit_scan == true):
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
	new_bullet = new_bullet.get_child(0) as Bullet
	new_bullet.initialize(_weapon_config)
