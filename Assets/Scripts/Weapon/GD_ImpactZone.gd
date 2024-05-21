extends Area3D
class_name ImpactZone

@onready var _collision_shape = $CollisionShape3D 
@onready var _mesh_instance = $MeshInstance3D 

var _initialized : bool = false
var _lifetime : float
var _damage_per_tick : float
var _tick_duration : float
var _damage_type

var _health_in_range = []


func initialize(radius, lifetime, damage_per_tick, tick_duration, damage_type):

	var sphere_collision = SphereShape3D.new()
	sphere_collision.radius = radius
	_collision_shape.shape = sphere_collision

	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	_mesh_instance.mesh = sphere_mesh

	_lifetime = lifetime
	_damage_per_tick = damage_per_tick
	_tick_duration = tick_duration
	_damage_type = damage_type

	_initialized = true


func _process(delta):

	_autodestruction(delta)


func _autodestruction(delta):

	_lifetime -= delta
	if (_lifetime < 0):
		self.queue_free()


func _on_area_entered(area : Area3D):

	if (area as HitBoxComponent):

		var new_health_in_zone = HealthInZone.new()
		new_health_in_zone.initialize(
			area.health_component,
			_tick_duration,
			_damage_per_tick,
			_damage_type
		)
		
		_health_in_range.append(new_health_in_zone)


func _on_area_exited(area : Area3D):

	if (area as HitBoxComponent):

		var new_health_in_zone = find_health(area.health_component)
		new_health_in_zone.stop()

		_health_in_range.erase(new_health_in_zone)


func find_health(health_component: HealthComponent) -> HealthInZone:
	
	for index in _health_in_range.size():

		if (_health_in_range[index]._health_component == health_component):

			return _health_in_range[index]
	
	return null


class HealthInZone:

	var _health_component: HealthComponent = null
	var _current_counter: float = 0
	var _counter_duration: float
	var _damage_per_tick: float
	var _damage_type
	var _initialized: bool = false
	var _activated: bool = true


	func initialize(health_component: HealthComponent, counter_duration: float, damage_per_tick: float, damage_type: int):

		_health_component = health_component
		_counter_duration = counter_duration
		_damage_per_tick = damage_per_tick
		_damage_type = damage_type

		# take damage on initialize
		_health_component.update_current_health(-_damage_per_tick, _damage_type)

		_initialized = true;


	func _process(delta):

		if (!_initialized):
			return
		
		if (!_activated):
			return

		_current_counter += delta

		if (_current_counter >= _counter_duration):

			_current_counter -= _counter_duration
			_health_component.update_current_health(-_damage_per_tick, _damage_type)


	func stop():
		
		_activated = false
