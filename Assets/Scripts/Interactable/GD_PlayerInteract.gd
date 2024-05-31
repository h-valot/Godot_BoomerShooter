extends Node
class_name PlayerInteract

@export var interactable: Interactable
@export var eventName = "Interact"


func _process(_delta):

	if Input.is_action_just_pressed(eventName):
		
		interactable.interact()
