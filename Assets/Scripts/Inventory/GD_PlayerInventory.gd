extends Node

class_name PlayerInventory

@export var inventoryUIInteractive: InventoryUIInteractive
@export var inventoryUI: InventoryUI

@export var eventName: String = "Inventory"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed(eventName):
		if inventoryUIInteractive.toogle_ui_standalone():
			inventoryUI.ui_container.hide()
		else:
			inventoryUI.ui_container.show()
