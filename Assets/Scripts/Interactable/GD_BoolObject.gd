extends Object

## Class to add comon feature to a bool,
## and allow the bool to be passed as ref using the class sharing rules.
class_name BoolObject

@export var value: bool = false

## Toggle the value
func toggle():
	value = !value;

## Optionaly set the value at start
func _init(new_value: bool = false):
	value = new_value

## Set the value to false
func to_false():
	value = false

## Set the value to true
func to_true():
	value = true

## Return the value
func out():
	return value
