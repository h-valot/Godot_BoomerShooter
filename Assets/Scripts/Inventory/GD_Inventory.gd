extends Node

class_name Inventory

signal on_add_item(item: ItemConfig)
signal on_remove_item(item: ItemConfig)
signal on_set_item_quantity(item: ItemConfig)

class Item:
	var config: ItemConfig
	var quantity: int

@export_category("Inventory")
@export var content = [] 

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
		var diff = (item_quantity + addition) - item.max_stack
		set_item_quantity(item, item_quantity + addition - diff)
		return diff
	else:
		set_item_quantity(item, item_quantity + addition)
		return 0

func remove_item(item: ItemConfig, substraction: int = 1):
	var new_quantity = get_item_quantity(item) - substraction
	
	if new_quantity < 0:
		new_quantity = 0

	set_item_quantity(item, new_quantity)
	emit_signal("on_remove_item", item)

func get_item_quantity(item: ItemConfig):
	var _item = find_item(item)
	if not _item:
		return 0
	return _item.quantity

func find_item(item: ItemConfig):
	for _item in content:
		if _item.config.name == item.name:
			return _item
	return null

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

func have_item(item: ItemConfig) -> bool:
	var _item = find_item(item)
	if _item == null:
		return false
	return _item.quantity > 0
