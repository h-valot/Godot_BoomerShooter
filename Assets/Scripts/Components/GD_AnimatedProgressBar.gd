extends Control
class_name AnimatedProgressBar

@export_category("Tweakable values")
@export_color_no_alpha var _upper_color : Color
@export_color_no_alpha var _under_color : Color
@export_color_no_alpha var _background_color : Color
@export_color_no_alpha var _border_color : Color
@export var _corner_radius : float = 3
@export var _corner_width : float = 1

@export_group("Internal references")
@export var _upper_progress_bar : ProgressBar
@export var _under_progress_bar : ProgressBar

var value : set = update_value
var direction : float


func initalize():

	_upper_progress_bar.add_theme_stylebox_override("fill", _create_new_sbf(_corner_radius, _corner_width, _upper_color, _border_color))
	_under_progress_bar.add_theme_stylebox_override("fill", _create_new_sbf(_corner_radius, _corner_width, _under_color, _border_color))
	_under_progress_bar.add_theme_stylebox_override("background", _create_new_sbf(_corner_radius, _corner_width, _background_color, _border_color))


func _create_new_sbf(corner_radius, corner_width, bg_color, border_color):
	var sbf = StyleBoxFlat.new()
	sbf.corner_radius_bottom_left = corner_radius
	sbf.corner_radius_bottom_right = corner_radius
	sbf.corner_radius_top_left = corner_radius
	sbf.corner_radius_top_right = corner_radius
	sbf.border_width_bottom = corner_width
	sbf.border_width_left = corner_width
	sbf.border_width_right = corner_width
	sbf.border_width_top = corner_width
	sbf.bg_color = bg_color
	sbf.border_color = border_color
	return sbf


func update_value(new_value):
		
	_upper_progress_bar.value = new_value

	if (_under_progress_bar.value < new_value):
		
		_under_progress_bar.value = new_value
		return

	while (_under_progress_bar.value != _upper_progress_bar.value):

		_under_progress_bar.value -= 0.01
		await get_tree().create_timer(0.05).timeout
