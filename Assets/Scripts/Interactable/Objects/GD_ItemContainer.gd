extends Node

@export var interactable: Interactable
@export var interactive_inventory_container: InventoryUIInteractive
@export var interactive_inventory_other: InventoryUIInteractive

func _ready():

	assert(interactable != null, "Missing interactable.")
	assert(interactable.inventory != null, "Interactable require an inventory.")

	assert(interactive_inventory_container != null, "Missing interactive inventory container")
	assert(interactive_inventory_other != null, "Missing interactive other inventory")
	
	interactable.on_interact.connect(_on_item_container_interact)



func _on_item_container_interact(_other: Node):

	var interactable =  _other as Interactable
	interactive_inventory_other.inventory = interactable.inventory
