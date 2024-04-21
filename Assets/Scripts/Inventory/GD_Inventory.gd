extends Node

class_name Inventory

signal on_add_item(item: ItemConfig)
signal on_remove_item(item: ItemConfig)
signal on_set_item_quantity(item: ItemConfig)

@export_category("Inventory")
@export var item_type: ItemConfig
@export var content: Dictionary 

func add_item(item: ItemConfig, addition: int = 1):
	emit_signal("on_add_item", item)
	if !item.stackable:
		set_item_quantity(item, 1)
		return 0
	
	var item_quantity: int = get_item_quantity(item)
	
	if item.max_stack != -1:
		var diff: int = item_quantity + addition - item.max_stack
		set_item_quantity(item, item_quantity + (addition - diff))
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
	var value = content[item]
	if value == null:
		return 0
	return value

func set_item_quantity(item: ItemConfig, quantity: int):
	if content[item] == null:
		content.keys().append(item)
		content[item] = quantity
	else:
		content[item] = quantity
	emit_signal("on_set_item_quantity", item)

func have_item(item: ItemConfig):
	return content[item] != null && content[item] > 0
