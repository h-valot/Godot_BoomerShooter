extends Area3D

class_name ConsumableObject

@export var parent: Node

var consumable: ConsumableConfig

func begin():
	InventoryUtils.call_latent_s(self, self, func(): parent.queue_free(), consumable.lifetime)

func _physics_process(_delta):
	apply_effects()

func apply_effects():
	var overlapping = get_overlapping_areas()
	if !overlapping.is_empty():
		var hit_target = false
		for object in overlapping:
			if UseConsumable.apply_consumable_effect(object, consumable, false):
				hit_target = true
		if hit_target:
			parent.queue_free()
