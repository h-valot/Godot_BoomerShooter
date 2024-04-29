extends Node
class_name PlayerHUD

@export_category("References")
@export var health_progress_bar : AnimatedProgressBar
@export var armor_progress_bar : AnimatedProgressBar

var _max_health : float
var _max_armor : float


func initialize(player_config : PlayerConfig):

	_max_health = player_config.base_health
	_max_armor = player_config.base_armor
	health_progress_bar.initalize()
	armor_progress_bar.initalize()


func update_health_bar(current_health):

	health_progress_bar.value = current_health / _max_health


func update_armor_bar(current_armor):

	armor_progress_bar.value = current_armor / _max_armor