extends Area3D
class_name InteractableArea

@export_category("Tweakable values")
@export var quest_condition_index: int = 0

@export_group("Forbidden")
@export var rse_interacted_in_area: RuntimeScriptableEventT1

var _player_in_area: bool = false


func _process(_delta):

	if (!_player_in_area):
		return

	if (Input.is_action_just_pressed("Interact")):
		rse_interacted_in_area.trigger(quest_condition_index)


func _on_area_entered(area):

	if (area as HitBoxComponent):
		_player_in_area = area.health_component.receiver_type == Enums.HealthType.PLAYER
