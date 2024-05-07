extends Area3D

## Trigger box for [Interactable]
class_name InteractableTriggerBox

@export var one_interaction_per_frame: bool = true

## Called when overlap another [Area3D]
signal on_overlap(other)

signal on_physic_process()

# Emit a signal for each overlapping actor
func _physics_process(_delta):
	on_physic_process.emit()
	var overlapping_bodies: Array
	overlapping_bodies = get_overlapping_areas()
	for overlapping_body in overlapping_bodies:
		var collider = overlapping_body as Area3D
		if (collider != null):
			on_overlap.emit(overlapping_body)
			if (one_interaction_per_frame):
				return;
