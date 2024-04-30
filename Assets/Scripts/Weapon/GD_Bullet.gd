extends Area3D
class_name Bullet

var _velocity = Vector3.ZERO
var _weapon_config : WeaponConfig
var _lifetime : float
var _initialized : bool = false
var _causer_type : int
var _zone_prefab : PackedScene

@onready var mesh_instance_3d = $MeshInstance3D
@onready var collision_shape_3d = $CollisionShape3D

signal collided(collider)


func initialize(weapon_config : WeaponConfig, zone_prefab : PackedScene, causer_type : int = 0):

	_weapon_config = weapon_config
	_lifetime = _weapon_config.bullet_lifetime
	_zone_prefab = zone_prefab
	_velocity = -transform.basis.z * _weapon_config.bullet_start_speed
	_initialized = true
	_causer_type = causer_type


func _physics_process(delta):

	if !_initialized:
		return
	
	_move(delta)
	_autodestruction(delta)


func _autodestruction(delta):

	_lifetime -= delta
	if (_lifetime < 0):
		self.queue_free()


func _move(delta):

	_velocity.y += -_weapon_config.bullet_gravity_scale * delta
	look_at(transform.origin + _velocity.normalized(), Vector3.UP)
	transform.origin += _velocity * delta


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

