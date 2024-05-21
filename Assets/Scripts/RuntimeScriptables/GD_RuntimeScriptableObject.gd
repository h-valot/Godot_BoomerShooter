extends Resource
class_name RuntimeScriptableObject

signal on_changed
var value: set = _set_value, get = _get_value


func _set_value(new_value):

	value = new_value
	on_changed.emit()


func _get_value():

	return value
