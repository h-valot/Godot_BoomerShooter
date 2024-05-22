extends Resource
class_name ConditionConfig


@export_category("References")
@export var condition: Enums.QuestCondition = Enums.QuestCondition.NONE


@export_category("Custom parameters")

@export_group("Time elapsed")
@export var duration: float = 0.0

@export_group("Interacted in area")
@export var interactable_areas_index: Array[int]

@export_group("Entity killed")
@export var entities_index: Array[int]

@export_group("Dialogue ended")
@export var dialogue_config: DialogueConfig = null


