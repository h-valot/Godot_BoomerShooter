extends Resource

class_name InteractableCondition

@export var require_faction: bool = false
@export var faction: InteractableFaction
@export var require_collision: bool = false

signal OnCompare(node_a: Node, node_b: Node, result: bool)

func compare(node_a: Node, node_b: Node) -> bool:
	assert(node_a != null, "Comparing with the first node as null.")
	assert(node_b != null, "Comparing with the second node as null.")

	var result = BoolObject.new(true)

	OnCompare.emit(node_a, node_b, result)
	
	# All checks should succeed to be able to interact
	return result.out()
