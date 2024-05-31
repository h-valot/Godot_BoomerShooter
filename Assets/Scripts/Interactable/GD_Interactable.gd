extends Node

## Instance of an Intaractable object, require to have an area as child with the script [InteractableTriggerBox]
class_name Interactable

## Called after an interaction was requested.
signal on_get_interaction(other: Node)
## Called when an interaction succeed all conditions.
signal on_interact(other: Interactable)
## Called when overlap another interactable.
signal on_get_interactable_overlap(other: Node)

@export var inventory: Inventory;
@export var interactable_index: InteractableIndex
@export var require_condition: bool = false
@export var condition_array: Array[Resource] = []
@export var interactable_faction: InteractableFaction
@export var interact_on_overlap: bool = false

@export var trigger_box: InteractableTriggerBox

@export_group("Forbidden")
@export var rse_interactable_interacted: RuntimeScriptableEventT1

var current_other_interactable: Interactable = null


func _ready():

	# If no InteractableTriggerBox, the interaction system cannot work
	assert(trigger_box != null, "Child 0 must be an InteractableTriggerBox");

	trigger_box.on_overlap.connect(_on_overlap)
	trigger_box.on_physic_process.connect(reset)
	on_get_interaction.connect(_on_get_interaction)


## Called when receive an interaction
func _on_get_interaction(other: Interactable):

	assert(other != null, "Other is null when get interaction.")
	
	if require_condition:
		# Skip if any condition failed
		for condition in condition_array:
			if (!condition.compare(other, self)):
				return

	on_interact.emit(other)
	rse_interactable_interacted.trigger(self)


func reset():

	current_other_interactable = null


func _on_overlap(other: Node):

	var other_interactible = other.get_parent() as Interactable

	if other_interactible != null:
		current_other_interactable = other_interactible
		on_get_interactable_overlap.emit()

		if interact_on_overlap:
			interact()


## Cause an interaction with the other [Interactable]
func interact():

	if (current_other_interactable != null):
		current_other_interactable.on_get_interaction.emit(self)


func _enter_tree():

	interactable_index.nodes.append(self)


func _exit_tree():

	interactable_index.nodes.remove_at(interactable_index.nodes.find(self))
