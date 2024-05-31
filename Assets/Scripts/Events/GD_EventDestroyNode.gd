extends Event
class_name EventDestroyNode

@export_category("Event")
@export var nodes_to_destroy: Array[Node]


func execute():
	
	super.execute()

	for node in nodes_to_destroy:

		node.queue_free()