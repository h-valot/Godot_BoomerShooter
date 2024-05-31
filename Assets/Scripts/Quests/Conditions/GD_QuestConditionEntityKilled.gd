extends QuestCondition
class_name QuestConditionEntityKilled

@export var entities: Array[Entity]

@export_group("Forbidden")
@export_subgroup("External references")
@export var rse_entity_killed: RuntimeScriptableEventT0

var entities_status: Dictionary
var entities_killed_amount: int = 0


func _ready():

	entities_status.clear()
	for entity in entities:

		entities_status[entity] = false

	rse_entity_killed.action.connect(check_entity_killed_amout)


func check_entity_killed_amout():

	for entity in entities:

		if (entities_status[entity] == true):
			continue

		if (!entity._is_alive):

			entities_status[entity] = true
			entities_killed_amount += 1