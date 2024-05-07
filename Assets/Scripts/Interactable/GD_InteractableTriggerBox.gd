extends Area3D

class_name InteractableTriggerBox

@export var one_interaction_per_frame: bool = true

signal on_overlap(other)

var overlapping_bodies: Array

# Emit a signal for each overlapping actor
func _physics_process(_delta):
	overlapping_bodies = get_overlapping_areas()
	for overlapping_body in overlapping_bodies:
		var collider = overlapping_body as Area3D
		if (collider != null):
			on_overlap.emit(overlapping_body)
			if (one_interaction_per_frame):
				return;
