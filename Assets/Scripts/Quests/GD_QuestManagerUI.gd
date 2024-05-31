extends CanvasLayer
class_name QuestManagerUI

@export_group("Forbidden")
@export_subgroup("External references")
@export var pf_quest_ui: PackedScene = null
@export var rse_quest_started: RuntimeScriptableEventT1 = null
@export var rse_quest_completed: RuntimeScriptableEventT1 = null
@export_subgroup("Internal references")
@export var quests_ui_content: VBoxContainer = null

var _quests_ui: Array[QuestUI]


func _ready():
	
	rse_quest_started.action.connect(add_quest_ui)
	rse_quest_completed.action.connect(remove_quest_ui)


func add_quest_ui(quest: Quest):

	assert(quest != null, "QUEST MANAGER UI: you are trying to instantiate a quest ui but the given quest is null")

	# exit, if the quest is not desplayed on screen
	if (!quest.display_on_screen):
		return

	var new_quest_ui = pf_quest_ui.instantiate()
	quests_ui_content.add_child(new_quest_ui)

	new_quest_ui = new_quest_ui as QuestUI
	new_quest_ui.initialize(quest.title, quest.description, quest._time_elapsed, quest._entities_killed)

	_quests_ui.push_back(new_quest_ui)


func remove_quest_ui(quest: Quest):

	for index in _quests_ui.size():

		if (_quests_ui[index].title.text == quest.title):

			_quests_ui[index].queue_free()
			_quests_ui.remove_at(index)
			return