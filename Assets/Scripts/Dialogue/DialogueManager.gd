extends Node
class_name DialogueManager

@export_category("References")
@export var rse_display_dialogue: WrapperActionT1 = null


func _process(delta):
	
	if (Input.is_action_just_pressed("Interact")):

		# todo - if it is an entity, check if it has dialogue config set up. if so, start a dialogue
		# it should look like some thing like that:
		# rse_display_dialogue.call(opponent.dialogue)
		pass
