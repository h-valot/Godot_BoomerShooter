extends Event
class_name EventSpawnNode

@export_category("Event")
@export var node_prefab: PackedScene = null
@export var spawn_parent: Node3D = null
@export var world_position: Vector3


func execute():
	
	super.execute()

	# instantiate an interactable as given world position
	assert(node_prefab != null, "EVENT SPAWN NODE: you are trying to instantiate a node prefab but it is empty or null")

	var new_node = node_prefab.instantiate()
	new_node.position = world_position

	if (spawn_parent):

		spawn_parent.add_child(new_node)

	else:

		print("EVENT SPAWN INTERACTABLE: spawn_parent is null, instantiate the node under the event")
		owner.add_child(new_node)