extends Control
class_name AnimatedProgressBar

@export_category("References")
@export var _upper_progress_bar : ProgressBar
@export var _under_progress_bar : ProgressBar

@export_color_no_alpha var _upper_color : Color
@export_color_no_alpha var _under_color : Color
@export_color_no_alpha var _border_color : Color
@export_color_no_alpha var _background_color : Color

var _upper_fill_style_box : StyleBox
var _under_fill_style_box : StyleBox

var _upper_background_style_box : StyleBox
var _under_background_style_box : StyleBox

var value : set = update_value


func _ready():

	# Upper setup
	_upper_fill_style_box =_upper_progress_bar.get_theme_stylebox("fill")
	_upper_background_style_box =_upper_progress_bar.get_theme_stylebox("background")
	_upper_fill_style_box.bg_color = _upper_color
	_upper_fill_style_box.border_color = _border_color

	# Under setup
	_under_fill_style_box = _under_progress_bar.get_theme_stylebox("fill")
	_under_background_style_box = _under_progress_bar.get_theme_stylebox("background")
	_under_fill_style_box.bg_color = _under_color
	_under_fill_style_box.border_color = _border_color
	_under_background_style_box.bg_color = _background_color
	_under_background_style_box.border_color = _border_color


func update_value(new_value):
	
	var old_value = _upper_progress_bar.value
	var delta = old_value - new_value
	print("update progress bar. new_value = ", new_value, " old_value = ", old_value, " delta = ", delta)
	_upper_progress_bar.value = old_value + delta
	animate(_under_progress_bar, delta)


func animate(progress_bar, delta):

	for i in abs(delta):

		await get_tree().create_timer(0.05).timeout
		if (delta < 0):

			progress_bar.value -= 1

		elif (delta > 0):

			progress_bar.value += 1
