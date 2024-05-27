extends Node
class_name QuestManager

@export_group("Forbidden")
@export var rse_player_died: RuntimeScriptableEventT0
@export var rse_time_elapsed: RuntimeScriptableEventT1
@export var rse_interacted_in_area: RuntimeScriptableEventT1
@export var rse_entity_killed: RuntimeScriptableEventT0
@export var rse_dialogue_ended: RuntimeScriptableEventT1
@export var rse_game_began: RuntimeScriptableEventT0

var _quests: Array[Quest]


func _ready():

	rse_player_died.action.connect(_on_player_died)
	rse_time_elapsed.action.connect(_on_time_elapsed)
	rse_interacted_in_area.action.connect(_on_interacted_in_area)
	rse_entity_killed.action.connect(_on_entity_killed)
	rse_dialogue_ended.action.connect(_on_dialogue_ended)
	rse_game_began.action.connect(_on_game_began)

	# save child quest into _quests array
	for child in self.get_children():
		if (child as Quest):
			_quests.push_back(child)
	
	# begin the game
	rse_game_began.trigger()


## to be tested
func _on_player_died():

	for quest in _quests:
		quest.check_conditions_of_type(Enums.QuestConditionType.PLAYER_DIED)


## not implemented yet
func _on_time_elapsed(timer: QuestConditionTimeElapsed):

	for quest in _quests:
		quest.check_conditions_of_type(Enums.QuestConditionType.TIME_ELAPSED, timer, null, null)


## to be tested
func _on_interacted_in_area(area: InteractableArea):

	for quest in _quests:
		quest.check_conditions_of_type(Enums.QuestConditionType.INTERACTED_IN_AREA, null, area, null)


func _on_entity_killed():

	for quest in _quests:
		quest.check_conditions_of_type(Enums.QuestConditionType.ENTITY_KILLED)


func _on_dialogue_ended(dialogue_config: DialogueConfig):

	print("on dialogue ended in quest manager with", dialogue_config.resource_name)

	for quest in _quests:
		quest.check_conditions_of_type(Enums.QuestConditionType.DIALOGUE_ENDED, null, null, dialogue_config)


func _on_game_began():

	for quest in _quests:
		quest.check_conditions_of_type(Enums.QuestConditionType.GAME_BEGAN)

