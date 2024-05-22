extends Node
class_name QuestManager

@export_category("References")
@export var quests: Array[QuestConfig]

@export_group("Forbidden references")
@export var rse_player_died: RuntimeScriptableEventT0
@export var rse_time_elapsed: RuntimeScriptableEventT1
@export var rse_interacted_in_area: RuntimeScriptableEventT1
@export var rse_entity_killed: RuntimeScriptableEventT1
@export var rse_dialogue_ended: RuntimeScriptableEventT1
@export var rse_game_began: RuntimeScriptableEventT0


func _ready():

	rse_player_died.action.connect(_on_player_died)
	rse_time_elapsed.action.connect(_on_time_elapsed)
	rse_interacted_in_area.action.connect(_on_interacted_in_area)
	rse_entity_killed.action.connect(_on_entity_killed)
	rse_dialogue_ended.action.connect(_on_dialogue_ended)
	rse_game_began.action.connect(_on_game_began)


func _on_player_died():

	for quest in quests:
		pass
	pass


func _on_time_elapsed(_timer_index: int):
	pass


func _on_interacted_in_area(_area_index: int):
	pass


func _on_entity_killed(_entity_index: int):
	pass


func _on_dialogue_ended(_dialogue_config: DialogueConfig):
	pass


func _on_game_began():
	pass

