extends Node

class_name PlayerInventory

@export var inventoryUIInteractive: InventoryUIInteractive
@export var inventoryUI: InventoryUI

@export var eventName = "Inventory"

func _process(_delta):
	if Input.is_action_just_pressed(eventName):
		if inventoryUIInteractive.toogle_ui_standalone():
			inventoryUI.ui_container.show()
		else:
			inventoryUI.ui_container.hide()
