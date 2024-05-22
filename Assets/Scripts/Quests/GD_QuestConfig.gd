extends Resource
class_name QuestConfig

@export_category("Debug")
@export var is_completed: bool = false

@export_category("Start")
@export var start_condition: ConditionConfig = null
@export var start_event: EventConfig = null


@export_category("Success")
@export var success_conditions: Array[ConditionConfig]
@export var success_events: Array[EventConfig]


@export_category("Failure")
@export var failure_conditions: Array[ConditionConfig]
@export var failure_events: Array[EventConfig]
