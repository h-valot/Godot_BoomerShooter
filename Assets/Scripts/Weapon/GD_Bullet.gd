extends Area3D
class_name Bullet

var _weapon_config : WeaponConfig
var _lifetime : float
var _initialized : bool = false
var _causer_type : int
var _zone_prefab : PackedScene
var _launched : bool = false
var _direction

@onready var mesh_instance_3d = $MeshInstance3D
@onready var collision_shape_3d = $CollisionShape3D

signal collided(collider)


func initialize(weapon_config : WeaponConfig, zone_prefab : PackedScene, causer_type : int = 0):

	_weapon_config = weapon_config
	_lifetime = _weapon_config.bullet_lifetime
	_zone_prefab = zone_prefab
	_initialized = true
	_causer_type = causer_type


func launch(from, to):

	global_position = from
	_direction = to
	_launched = true


func _physics_process(delta):

	if (!_initialized):
		return
	
	_move(delta)
	_autodestruction(delta)


func _autodestruction(delta):

	_lifetime -= delta
	if (_lifetime < 0):
		self.queue_free()


func _move(delta):

	if (!_launched):
		return

	_direction = _direction.normalized() * (_weapon_config.bullet_start_speed * delta);
	transform.origin += _direction
	
	#_velocity.y += -_weapon_config.bullet_gravity_scale * delta
	#look_at(global_position + _direction, Vector3.UP)


func _on_area_entered(area):

	if (area as HitBoxComponent):

		if (_weapon_config.create_zone_on_impact):
			_generate_zone()
			self.queue_free()
			return;

		area.health_component.update_current_health(-_weapon_config.bullet_damage, _causer_type)
		self.queue_free()



func _on_body_entered(body : Node3D):
	
	if (!_weapon_config.create_zone_on_impact):
		return;

	_generate_zone()
	self.queue_free()


func _generate_zone():

	var new_zone = _zone_prefab.instantiate()
	get_parent().add_child(new_zone)
	
	new_zone.position = global_position
	new_zone.initialize(
		_weapon_config.zone_radius, 
		_weapon_config.zone_lifetime, 
		_weapon_config.zone_damage_per_tick, 
		_weapon_config.zone_tick_duration, 
		_causer_type
	)

