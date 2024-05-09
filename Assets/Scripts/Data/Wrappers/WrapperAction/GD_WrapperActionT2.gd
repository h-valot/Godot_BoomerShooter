extends Resource
class_name WrapperActionT2

signal action(param1, param2)

func trigger(param1, param2):
	emit_signal("action", param1, param2)
