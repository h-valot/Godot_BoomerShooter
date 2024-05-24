extends Event
class_name EventForceInteraction

@export_category("Event")
@export var interactable: Interactable = null


func execute():
	
	super.execute()

	# emit the on interact signal with the player interaction box
	pass