extends CanvasLayer
class_name DialogueUI

@export_category("Tweakable values")
@export var char_read_rate: float = 0.025
@export_category("References")
@export var rse_display_dialogue: WrapperActionT1 = null

var _current_state = State.READY
var _dialogue_apparition_tween: Tween = null
var _dialogue_queue = []

@onready var dialogue_box = $DialogueBox_MarginContainer
@onready var label = $DialogueBox_MarginContainer/InnerText_MarginContainer/InnerText_HBoxContainer/Label
@onready var end = $DialogueBox_MarginContainer/InnerText_MarginContainer/InnerText_HBoxContainer/End

enum State { READY, READING, FINISHED }


func _ready():

	rse_display_dialogue.action.connect(_fill_queue)
	_hide_dialogue()


func _process(delta):

	_handle_states()


func _handle_states():

	match _current_state:

		State.READY:
			
			if (!_dialogue_queue.is_empty()):
				_display_sentence()
		
		State.READING:

			if (Input.is_action_just_pressed("ui_accept")):
				
				_dialogue_apparition_tween.stop()
				label.visible_ratio = 1.0

			if (label.visible_ratio >= 1.0):

				_change_state(State.FINISHED)
				end.text = "v"
		
		State.FINISHED:

			if (Input.is_action_just_pressed("ui_accept")):

				_change_state(State.READY)
				_hide_dialogue()


func _fill_queue(new_queue):

	for index in len(new_queue):
		_dialogue_queue.push_back(new_queue[index])


func _display_sentence():

	var new_text = _dialogue_queue.pop_front()
	label.text = new_text
	_change_state(State.READING)
	_show_dialogue()

	# animate the dialogue
	label.visible_ratio = 0.0
	_dialogue_apparition_tween = get_tree().create_tween()
	_dialogue_apparition_tween.tween_property(label, "visible_ratio", 1.0, len(new_text) * char_read_rate).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _change_state(new_state):

	_current_state = new_state


func _hide_dialogue():

	label.text = ""
	end.text = ""
	dialogue_box.hide()


func _show_dialogue():

	dialogue_box.show()