extends Resource
class_name WrapperActionT1

signal action(param)

func trigger(param):
	emit_signal("action", param)
