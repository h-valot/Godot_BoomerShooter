extends Resource
class_name WrapperActionT0

signal action

func trigger():
	emit_signal("action")
