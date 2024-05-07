extends Resource
class_name PlayerConfig

@export_group("Main properties")
@export var base_health : float = 100
@export var health_regeneration : float = 5
@export var base_armor : float = 50


@export_group("Movement properties")

@export_subgroup("Movement speed settings")
@export var base_move_speed : float = 10
@export var sprint_move_speed : float = 12.5
@export_range(0, 1) var air_control_scalar : float = 1
@export var move_speed_acceleration : float = 10

@export_subgroup("Mouse settings")
@export var horizontal_mouse_sensitivity : float = 0.4
@export var vertical_mouse_sensitivity : float = 0.2
@export var max_vertical_aim : float = 89

@export_subgroup("Jump settings")
@export var jump_force : float = 4.5
@export_multiline var gravity_hint : String = "You can tweak the gravity value (9.8) in the project settings > physics > 3d > default gravity"


@export_group("Combat properties")
@export var i_frame_duration : float = 0.5 
@export var consumable_switch_time : float = 0.25
