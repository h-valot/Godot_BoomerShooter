extends InteractableCondition

## Valid an interaction if both object are overlaping.
class_name ConditionCollision

func _ready():
    OnCompare.connect(self.on_compare)

func on_compare(node_a, node_b, result: BoolObject):
    if (require_collision):
        var collision_object_a = node_a.get_child(0) as CollisionObject3D
        var collision_object_b = node_b.get_child(0) as CollisionObject3D
		
        if (collision_object_a == null):
            printerr("Failed to get interactable A child 0 as CollisionObject3D")
            result.to_false()
		
        if (collision_object_b == null):
            printerr("Failed to get interactable B child 0 as CollisionObject3D")
            result.to_false()
		
        if (collision_object_a.collsion_info.get_overlapping_areas().find(collision_object_b) < 0):
            result.to_false()
