extends Node
class_name Quest

@export_group("Debug")
@export var is_completed: bool = false
@export var is_started: bool = false

var start_conditions: Array[QuestCondition]
var start_events: Array[Event]

var success_conditions: Array[QuestCondition]
var success_events: Array[Event]

var failure_conditions: Array[QuestCondition]
var failure_events: Array[Event]

@onready var start_folder = $Start
@onready var success_folder = $Success
@onready var failure_folder = $Failure


func _ready():

	_fill_conditions(start_folder)
	_fill_events(start_folder)

	_fill_conditions(success_folder)
	_fill_events(success_folder)

	_fill_conditions(failure_folder)
	_fill_events(failure_folder)


func _fill_conditions(folder):

	for child in folder.get_children():

		if (child as QuestCondition):

			match folder:

				start_folder:
					start_conditions.push_back(child)

				success_folder:
					success_conditions.push_back(child)

				failure_folder:
					failure_conditions.push_back(child)


func _fill_events(folder):

	for child in folder.get_children():

		if (child as Event):

			match folder:

				start_folder:
					start_events.push_back(child)

				success_folder:
					success_events.push_back(child)

				failure_folder:
					failure_events.push_back(child)


func start():

	print("QUEST: ", owner.name, " started")
	_trigger_events(start_events)
	start_timers()
	is_started = true


func start_timers():

	for condition in start_events:
		if (condition.type == Enums.QuestConditionType.TIME_ELAPSED):
			condition.start_timer()


var _timer = null
var _area = null
var _dialogue = null
func check_conditions_of_type(type: Enums.QuestConditionType, timer = null, area = null, dialogue = null):

	_timer = timer
	_area = area
	_dialogue = dialogue

	if (!is_started):
		check_conditions(start_conditions, start_events, type, true)

	if (is_started):
		check_conditions(success_conditions, success_events, type)
		check_conditions(failure_conditions, failure_events, type)


func check_conditions(conditions: Array[QuestCondition], events: Array[Event], type: Enums.QuestConditionType, check_for_start: bool = false):

	if (is_completed):
		return

	var count: int = 0
	for condition in conditions:

		if (condition.type == type):

			condition.is_completed = false

			if (type == Enums.QuestConditionType.PLAYER_DIED
			|| type == Enums.QuestConditionType.GAME_BEGAN):

				condition.is_completed = true

			# additional check: timer
			if (type == Enums.QuestConditionType.TIME_ELAPSED):

				assert(_timer == null, "QUEST: the given timer is null")

				if (_timer == condition
				&& _timer._is_ended):

					condition.is_completed = true

			# additional check: area identity
			if (type == Enums.QuestConditionType.INTERACTED_IN_AREA):

				assert(_area == null, "QUEST: the given area is null")

				if (condition.interactable_area == _area):
					condition.is_completed = true

			# additional check: entities status
			if (type == Enums.QuestConditionType.ENTITY_KILLED):

				var entity_killed_count: int = 0
				for entity in condition.entities:

					if (!entity._is_alive):
						entity_killed_count += 1
				
				if (entity_killed_count >= condition.entities.size()):
					condition.is_completed = true

			# additional check: dialogue identity
			if (type == Enums.QuestConditionType.DIALOGUE_ENDED):

				assert(_dialogue == null, "QUEST: the given dialogue is null")

				if (condition.dialogue_config == _dialogue):
					condition.is_completed = true

		if (condition.is_completed):
			count += 1

	if (count >= conditions.size()):

		if (check_for_start):
			start()
		else:
			is_completed = true
			print("QUEST: success or failures")
			
		_trigger_events(events)


func _trigger_events(events: Array[Event]):
	
	for event in events:

		event.execute()
