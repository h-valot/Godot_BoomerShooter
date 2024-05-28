extends Event
class_name EventForceInteraction

@export_category("Event")
@export var interactable: Interactable

@export_group("Forbidden")
@export var rso_player_interactable: RuntimeScriptableObject


func execute():
	
	super.execute()

	# emit the on interact signal with the player interaction box
	interactable._on_get_interaction(rso_player_interactable.value)