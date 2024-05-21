extends Resource
class_name RuntimeScriptableEventT2

signal action(param1, param2)


func trigger(param1, param2):

	action.emit(param1, param2)
