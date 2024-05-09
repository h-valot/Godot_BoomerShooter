extends Node3D

class_name Door

@export var interactable: Interactable
@export var speed: float

var is_open: bool = false

func _ready():
	interactable.on_interact.connect(_on_interact.bind())

func _on_interact(_other):
	is_open = !is_open

func _process(delta):
	if (is_open && rad_to_deg(transform.basis.get_euler().y) < 90):
		rotate(Vector3.UP, speed * delta)
	elif (!is_open && rad_to_deg(transform.basis.get_euler().y) > 0):
		rotate(-Vector3.UP, speed * delta)
	elif (is_open):
		rotation_degrees.y = 90;
	elif (!is_open):
		rotation_degrees.y = 0;
