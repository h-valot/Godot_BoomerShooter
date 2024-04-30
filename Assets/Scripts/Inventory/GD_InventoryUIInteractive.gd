extends InventoryUI

## Inherit from [InventoryUI] and make it interactable by the user.
class_name InventoryUIInteractive

signal on_show(other: InventoryUI)
signal on_hide(other: InventoryUI)

@export var interactable: Interactable

var _other_inventory: Inventory;

func _ready():
	on_show.connect(_on_show)
	show_ui_standalone()

	assert(interactable != null, "Missing interactable")
	interactable.on_interact.connect(_on_interact)

func _on_interact(other: Interactable):
	print("On interact")
	var other_inventory_buffer = InventoryUtils.get_child_of_type(other, typeof(InventoryUI))
	if other_inventory_buffer != null:
		_other_inventory = other_inventory_buffer

func _on_show(_other):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_hide(_other):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	_other_inventory = null

## Show the UI of the current inventory
func show_ui_standalone():
	on_show.emit(null)
	_update_ui()

## hide the UI of the current inventory
func hide_ui_standalone():
	on_hide.emit(null)
	_clear_ui()

## Show the UI
func show_ui_compare(other: InventoryUI):
	_other_inventory = other.inventory
	
	on_show.emit(other)
	
	other._update_ui()
	_update_ui()

	on_action_item.connect(_on_self_item_action)
	other.on_action_item.connect(_on_other_item_action)

func _on_other_item_action(item):
	_other_inventory.add_item(item, -1)
	inventory.add_item(item);

func _on_self_item_action(item):
	assert(_other_inventory != null, "Other inventory must not be null")

	inventory.add_item(item, -1)
	_other_inventory.add_item(item)

## Hide the UI
func hide_ui_compare(other: InventoryUI):
	_other_inventory = null
	on_hide.emit(other)
	other._clear_ui()
	_clear_ui()

	on_action_item.disconnect(_on_self_item_action)
	other.on_action_item.disconnect(_on_other_item_action)
