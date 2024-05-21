extends Resource
class_name RuntimeScriptableEventT1

signal action(param)


func trigger(param):

	action.emit(param)
