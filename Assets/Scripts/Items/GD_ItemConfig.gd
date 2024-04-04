extends Resource
class_name ItemConfig

@export var name : String = ""
@export var item_mesh : PackedScene

@export_group("Stack")
@export var quantity : float = 1
@export var max_stack : float = -1
@export var stackable : bool = true
