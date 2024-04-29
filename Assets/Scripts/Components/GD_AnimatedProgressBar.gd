extends Control
class_name AnimatedProgressBar

@export_category("Tweakable values")
@export_color_no_alpha var _upper_color : Color
@export_color_no_alpha var _under_color : Color
@export_color_no_alpha var _background_color : Color
@export_color_no_alpha var _border_color : Color

@export_group("Internal references")
@export var _upper_progress_bar : ProgressBar
@export var _under_progress_bar : ProgressBar

var _sbf_upper_fill : StyleBoxFlat
var _sbf_under_fill : StyleBoxFlat
var _sbf_under_background : StyleBoxFlat

var value : set = update_value
var direction : float


func initalize():

	_sbf_upper_fill = _upper_progress_bar.get_theme_stylebox("fill")
	_sbf_upper_fill.bg_color = _upper_color
	_sbf_upper_fill.border_color = _border_color

	_sbf_under_fill = _under_progress_bar.get_theme_stylebox("fill")
	_sbf_under_fill.bg_color = _under_color
	_sbf_under_fill.border_color = _border_color

	_sbf_under_background = _under_progress_bar.get_theme_stylebox("background")
	_sbf_under_background.bg_color = _background_color
	_sbf_under_background.border_color = _border_color


func update_value(new_value):
		
	direction = 1
	if (new_value > 0):

		direction = -1

	_upper_progress_bar.value = new_value

	while (_under_progress_bar.value != _upper_progress_bar.value):

		_under_progress_bar.value += 0.01 * direction
		await get_tree().create_timer(0.1).timeout
