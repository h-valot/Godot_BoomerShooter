extends Resource
class_name WrapperVariable

signal on_changed
var _value: set = _set_value, get = _get_value

func _set_value(new_value):
	_value = new_value
	emit_signal("on_changed")
	
func _get_value():
	return _value
