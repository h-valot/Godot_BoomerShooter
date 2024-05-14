extends Resource

## Condition called to check if a interaction is possible, used by [Interactable].
class_name InteractableCondition

@export var require_faction: bool = false
@export var faction: InteractableFaction
@export var require_collision: bool = false

func on_compare(_node_a: Node, _node_b: Node, _result: BoolObject):
	pass

## Compare two node to know if they can interact.
func compare(node_a: Node, node_b: Node) -> bool:
	assert(node_a != null, "Comparing with the first node as null.")
	assert(node_b != null, "Comparing with the second node as null.")

	var result = BoolObject.new(true)

	on_compare(node_a, node_b, result)
	
	# All checks should succeed to be able to interact
	return result.out()
