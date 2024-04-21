extends Resource

class_name InteractableIndex

var nodes: Array

func _init():
	Performance.add_custom_monitor("Interaction System/Interactable", _get_node_count)

func _get_node_count():
	return nodes.size()
