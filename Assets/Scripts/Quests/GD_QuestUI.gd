extends Control
class_name QuestUI

@export_group("Forbidden")
@export_subgroup("External references")
@export var rse_entity_killed: RuntimeScriptableEventT0
@export_subgroup("Internal references")
@export var title: Label = null
@export var timer: Label = null
@export var description: Label = null
@export var param: Label = null

var _timer: QuestConditionTimeElapsed = null
var _entities_killed: QuestConditionEntityKilled
var _entity_killed_count: int = 0
var _is_initialized: bool = false


func _ready():

	rse_entity_killed.action.connect(_update_entity_killed_count)


func initialize(new_title: String, new_description: String, new_timer: QuestConditionTimeElapsed = null, new_entities_killed: QuestConditionEntityKilled = null):

	title.text = new_title
	description.text = new_description
	_timer = new_timer
	_entities_killed = new_entities_killed

	if (new_timer == null):
		print("timer is null")
		timer.text = ""

	if (_entities_killed != null):
		if (_entities_killed.entities_status.size() <= 0):
			param.text = ""
		else:
			_update_entity_killed_count()
	
	_is_initialized = true


func _update_entity_killed_count():

	if (_entities_killed.entities_status.size() <= 0):
		return
		
	param.text = str("[", _entities_killed.entities_killed_amount, "/", _entities_killed.entities_status.size(), "]")
		

func _process(_delta):

	if (!_is_initialized):
		return

	if (_timer == null):
		return

	var minutes = floor(_timer._current_timer / 60)
	var seconds = int(_timer._current_timer) % 60
	timer.text = "%02d:%02d" % [minutes, seconds]
