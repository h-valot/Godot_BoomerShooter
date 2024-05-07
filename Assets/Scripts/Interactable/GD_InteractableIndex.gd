extends Resource

## Index of all interactable, primary made for debug mesure.
class_name InteractableIndex

var nodes: Array

func _init():
	Performance.add_custom_monitor("Interaction System/Interactable", _get_node_count)

## Return the count of interactable in registred.
func _get_node_count():
	return nodes.size()
