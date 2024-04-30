
class_name InventoryUtils

static func get_child_of_type(parent: Node, type: int):
    for child in parent.get_children():
        if typeof(child) == type:
            return child
    return null
