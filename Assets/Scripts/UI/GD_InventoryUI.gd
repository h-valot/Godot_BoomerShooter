extends Node2D

## Show the content of an inventory.
class_name InventoryUI

signal on_update_ui()
signal post_on_update_ui()
signal on_remove_child(child: Node)
signal on_action_item(item: ItemConfig)

@export var inventory: Inventory
@export var text_position: Vector2
@export var text_side: Side
@export var text_anchor: float
@export var hide_quantity_when_one: bool
@export var style_box_highlight: StyleBox
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

func _on_action_item(item: ItemConfig):
	assert(item != null, "Action on null item")
	on_action_item.emit(item)

## Update the UI when an item quantity changed.
## Items are rendered as [Button].
## A [Label] show the quantity.
func _update_ui():
	on_update_ui.emit()

	_clear_ui()

	for inventory_item in inventory.content:
		var item_config = inventory_item as ItemConfig
		if item_config != null:
			var itemButton = Button.new()
			
			itemButton.pressed.connect(func(): _on_action_item(item_config))
			assert(item_config.icon != null, "Missing icon for " + item_config.name)
			itemButton.texture = item_config.icon

			var quantity = inventory.content[inventory_item]

			if (hide_quantity_when_one && quantity != 1) || !hide_quantity_when_one:
				var text = Label.new()

				text.text = String.num_int64(quantity)
				text.position = text_position
				text.set_anchor(text_side, text_anchor)

				itemButton.add_child(text)
			$Container.add_child(itemButton)
	post_on_update_ui.emit()

	_ui_visible = true
