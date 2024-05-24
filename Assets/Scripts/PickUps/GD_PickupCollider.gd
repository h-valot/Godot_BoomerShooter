extends Area3D

class_name PickUpCollider

@export var inventory: Inventory = null

func _ready():
	assert(inventory != null, "Missing inventory")
