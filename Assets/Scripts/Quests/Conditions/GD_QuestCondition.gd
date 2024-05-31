extends Node
class_name QuestCondition

@export_group("Forbidden")
@export var type: Enums.QuestConditionType = Enums.QuestConditionType.NONE

var is_completed: bool = false