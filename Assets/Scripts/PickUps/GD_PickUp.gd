extends Node3D

## Object pickable by an interactable with an inventory
class_name PickUp

@export var inventory: Inventory
@export var item: ItemConfig 
@export var interactable: Interactable
@export var destroy_when_item_transferred: bool = true

func _ready():
	assert(item != null, "Missing item.")
	assert(interactable != null, "Missing interactable.")

	interactable.on_interact.connect(_on_pickup_interact)
	interactable.trigger_box.on_overlap.connect(_on_overlap_pickup)

func _on_overlap_pickup():
	interactable.interact()

func _on_pickup_interact(other: Interactable):
	assert(other.inventory != null, "Missing reference to inventory.")
	other.inventory.add_item(item)
	if (destroy_when_item_transferred):
		queue_free()
