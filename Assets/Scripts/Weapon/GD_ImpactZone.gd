extends Area3D
class_name ImpactZone

@onready var _collision_shape = $CollisionShape3D 
@onready var _mesh_instance = $MeshInstance3D 

var _initialized : bool = false
var _lifetime : float
var _damage_per_tick : float
var _tick_duration : float
var _tick_timer : float = 0
var _damage_type

var _hitbox_in_range = []


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
	_handle_damage(delta)


func _autodestruction(delta):

	_lifetime -= delta
	if (_lifetime < 0):
		self.queue_free()


func _handle_damage(delta):

	_tick_timer += delta
	if (_tick_timer < _tick_duration): return
	_tick_timer -= _tick_duration

	for i in len(_hitbox_in_range):

		_hitbox_in_range[i].update_current_health(-_damage_per_tick, _damage_type)


func _on_area_entered(area : Area3D):

	if (area as HitBoxComponent):

		_hitbox_in_range.append(area.health_component)


func _on_area_exited(area : Area3D):

	if (area as HitBoxComponent):

		_hitbox_in_range.erase(area.health_component)
