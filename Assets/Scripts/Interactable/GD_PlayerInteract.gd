extends Node

class_name PlayerInteract

@export var interactable: Interactable

func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		interactable.interact()
