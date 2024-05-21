extends Node
class_name CharacterHUD

@export_category("References")
@export var health_progress_bar : AnimatedProgressBar
@export var armor_progress_bar : AnimatedProgressBar

var _max_health : float
var _max_armor : float


func initialize(player_config : CharacterConfig):

	_max_health = player_config.base_health
	health_progress_bar.initalize()

	if (player_config.base_armor > 0):
		armor_progress_bar.show()
		_max_armor = player_config.base_armor
		armor_progress_bar.initalize()
	else:
		armor_progress_bar.hide()


func update_health_bar(current_health):

	health_progress_bar.value = current_health / _max_health


func update_armor_bar(current_armor):

	if (armor_progress_bar.hidden):
		armor_progress_bar.show()
	
	armor_progress_bar.value = current_armor / _max_armor