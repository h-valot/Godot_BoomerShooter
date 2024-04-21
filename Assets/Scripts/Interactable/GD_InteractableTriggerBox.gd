extends Area3D

class_name InteractableTriggerBox

signal on_overlap(other)

var overlapping_bodies: Array

# Emit a signal for each overlapping actor
func _physics_process(_delta):
	overlapping_bodies = get_overlapping_areas()
	for overlapping_body in overlapping_bodies:
		var collider = overlapping_body as Area3D
		if (collider == null):
			continue
		
		if (collider.get_collision_layer_value(2)):
			on_overlap.emit(overlapping_body)
