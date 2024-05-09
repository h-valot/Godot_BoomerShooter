extends Node

## Store [Item]s as [ItemConfig] and their quantity 
class_name Inventory

signal on_add_item(item: ItemConfig)
signal on_remove_item(item: ItemConfig)
signal on_set_item_quantity(item: ItemConfig)

## Represent an item in the [Inventory].
class Item:
	var config: ItemConfig
	var quantity: int

@export_category("Inventory")
@export var content: Array = []

## Add an item or increase it's quantity stored in the inventory.
func add_item(item: ItemConfig, addition: int = 1):
	assert(item != null, "Item is null")

	emit_signal("on_add_item", item)
	if !item.stackable:
		if addition > 1:
			addition = 1
		elif addition < 0:
			addition = 0
		
		set_item_quantity(item, addition)
		return 0

	var item_quantity: int = get_item_quantity(item)

	if (item_quantity + addition) > item.max_stack:
		var diff: float = (item_quantity + addition) - item.max_stack
		set_item_quantity(item, item_quantity + addition - int(diff))
		return diff
	else:
		set_item_quantity(item, item_quantity + addition)
		return 0

## Substract the quantity of an item, but do not remove the instance from the array.
func remove_item(item: ItemConfig, substraction: int = 1):
	var new_quantity = get_item_quantity(item) - substraction
	
	if new_quantity < 0:
		new_quantity = 0

	set_item_quantity(item, new_quantity)
	emit_signal("on_remove_item", item)

## Return the quantity stored of this item.
func get_item_quantity(item: ItemConfig):
	var _item = find_item(item)
	if not _item:
		return 0
	return _item.quantity

## Return the item instance in the content.
func find_item(item: ItemConfig):
	for _item in content:
		if _item.config.name == item.name:
			return _item
	return null

## Set the stored quantity in a specific item.
func set_item_quantity(item: ItemConfig, quantity: int):
	for _item in content:
		if _item.config == item:
			_item.quantity = quantity
			emit_signal("on_set_item_quantity", item)
			return
	var new_item = Item.new()
	new_item.config = item
	new_item.quantity = quantity;
	content.append(new_item)

## Check if the item is in the inventory and if it is stored as more than 0.
func have_item(item: ItemConfig) -> bool:
	var _item = find_item(item)
	if _item == null:
		return false
	return _item.quantity > 0

func toggle():
	pass
