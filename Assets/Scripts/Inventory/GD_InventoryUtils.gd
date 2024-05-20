
class_name InventoryUtils

## Get the child of a node based on it's type
static func get_child_of_type(parent: Node, type: int):
	for child in parent.get_children():
		if typeof(child) == type:
			return child
	return null

## Get the childs of a node based on a type
static func get_childs_of_type(parent: Node, type: int) -> Array[Opponent]:
	var result: Array[Opponent] = []
	
	for child in parent.get_children():
		if typeof(child) == type:
			result.append(child)
	
	return result

static func call_latent(base_node: Node, callable: Callable, cool_down: float):
	await base_node.get_tree().create_timer(cool_down).timeout
	callable.call()

static func call_latent_s(base_node: Node, target: Node, callable: Callable, cool_down: float):
	await base_node.get_tree().create_timer(cool_down).timeout
	if target != null:
		callable.call()
