extends Node2D

## Show the content of an [Inventory].
class_name InventoryUI

signal on_update_ui()
signal post_on_update_ui()
signal on_remove_child(child: Node)
signal on_action_item(item: ItemConfig)
signal on_throw_item(item: ItemConfig)

@export var inventory: Inventory
@export var text_position: Vector2
@export var text_side: Side
@export var text_anchor: float
@export var hide_quantity_when_one: bool
@export var hide_when_zero: bool = true
@export var ui_container: Container

## Update UI on ready
@export var show_ui_on_ready: bool = true

var _ui_visible: bool = false

func _ready():
	assert(inventory != null, "Missing inventory")
	assert(ui_container != null, "Missing UI [Container].")

	if show_ui_on_ready:
		_on_changed(null)
	
	inventory.on_set_item_quantity.connect(_on_changed)

## Remove all the children of the [Container]
func _clear_ui():
	for child in ui_container.get_children():
		ui_container.remove_child(child)
		on_remove_child.emit(child)
		child.queue_free()
	_ui_visible = false

func _on_changed(_item: ItemConfig):
	_update_ui()

func _on_action_item(button: Button, item: ItemConfig):
	assert(item != null, "Action on null item")
	if !button.button_pressed:
		on_action_item.emit(item)

func _on_throw_item(button: Button, item: ItemConfig):
	assert(item != null, "Throw on null item")
	if button.button_pressed:
		on_throw_item.emit(item)

## Update the UI when an item quantity changed.
## Items are rendered as [Button].
## A [Label] show the quantity.
func _update_ui():
	on_update_ui.emit()

	_clear_ui()

	for inventory_item in inventory.content:
		assert(inventory_item.config != null, "Item (dictionnary key) must be an ItemConfig")
		if !(inventory_item.quantity == 0 && hide_when_zero):
			var itemButton = Button.new()
			
			assert(inventory_item.config.icon != null, "Missing icon for " + inventory_item.config.name)
			itemButton.icon = inventory_item.config.icon

			if (inventory_item.config as ConsumableConfig) == null:
				itemButton.set_process_input(false)
			else:
				itemButton.button_down.connect(func(): InventoryUtils.call_latent(self, func(): _on_action_item(itemButton, inventory_item.config), 0.1))
				itemButton.button_down.connect(func(): InventoryUtils.call_latent(self, func(): _on_throw_item(itemButton, inventory_item.config), 0.1))

			if (hide_quantity_when_one && inventory_item.quantity != 1) || !hide_quantity_when_one:
				var text = Label.new()

				text.text = String.num_int64(inventory_item.quantity)
				text.position = text_position
				text.set_anchor(text_side, text_anchor)

				itemButton.add_child(text)
			ui_container.add_child(itemButton)
	post_on_update_ui.emit()

	_ui_visible = true
