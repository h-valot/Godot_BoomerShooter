extends Node

## Utility node to initialize an inventory.
## Exist because cannot use dictionnary directly without getting imprevisible behaviour.
## Check using assert for wrong type in the dictionnary.
class_name InventoryInitializer

@export var inventory: Inventory
@export var items: Dictionary

func _ready():
	for item in items:
		assert(typeof(item) == typeof(ItemConfig), "The key must be an item.")
		assert(typeof(items[item]) == TYPE_INT, "The value must be an int.")
		inventory.set_item_quantity(item, items[item])
	# Destroy the node after use
	queue_free()
