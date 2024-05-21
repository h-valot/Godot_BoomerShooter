extends Node
class_name PlayerInventory

@export var inventoryUIInteractive: InventoryUIInteractive
@export var inventoryUI: InventoryUI
@export var rse_enable_inventory: RuntimeScriptableEventT1 = null
@export var eventName: String = "Inventory"

var _enabled: bool = true


func _ready():

	rse_enable_inventory.action.connect(_change_state)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _change_state(new_state: bool):

	_enabled = new_state


func _process(_delta):

	if (!_enabled):
		return

	if (Input.is_action_just_pressed(eventName)):

		if (inventoryUIInteractive.toogle_ui_standalone()):

			inventoryUI.ui_container.hide()

		else:

			inventoryUI.ui_container.show()
