extends Node

## Instance of an Intaractable object, require to have an area as child with  the script [InteractableTriggerBox]
class_name Interactable

signal OnGetInteraction(other: Node)
signal OnInteract(other: Node)

@export var interactable_index: InteractableIndex
@export var require_condition: bool = false
@export var condition_array: Array = []
@export var interactable_faction: InteractableFaction

@onready var trigger_box = get_child(0) as InteractableTriggerBox

var current_other_interactable: Interactable = null

func _ready():
	# If no InteractableTriggerBox, the interaction system cannot work
	if (trigger_box == null):
		printerr("Child 0 must be an InteractableTriggerBox")
		self.queue_free()
	else:
		trigger_box.on_overlap.connect(on_overlap)
		OnGetInteraction.connect(on_get_interaction)

## Called when receive an interaction
func on_get_interaction(other: Interactable):
	# Skip if any condition failed
	for condition in other.condition_array:
		if (!condition.compare(other, self)):
			return
	OnInteract.emit(other)

func on_overlap(other: Node):
	var other_interactible = other.get_parent() as Interactable
	if (other_interactible != null):
		current_other_interactable = other_interactible

func interact():
	if (current_other_interactable != null):
		current_other_interactable.OnGetInteraction.emit(self)

func _enter_tree():
	interactable_index.nodes.append(self)

func _exit_tree():
	interactable_index.nodes.remove_at(interactable_index.nodes.find(self))
