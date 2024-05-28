extends QuestCondition
class_name QuestConditionTimeElapsed

@export_category("Quest")
@export var timer_duration: float = 0.0

@export_group("Forbidden")
@export var rse_time_elapsed: RuntimeScriptableEventT1

var _is_started: bool = false
var _is_ended: bool = false
var _current_timer: float = 0.0


func start_timer():

	_is_started = true
	_current_timer = timer_duration


func _process(delta):

	if (!_is_started
	|| _is_ended):
		return

	_current_timer -= delta
	if (_current_timer <= 0):

		_is_ended = true
		rse_time_elapsed.trigger(self)