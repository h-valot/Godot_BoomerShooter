extends InteractableCondition

class_name ConditionItem

@export var item: ItemConfig
@export var exceptedToHave: bool = true 

## Called when a comparaison happend,
## you can refuse the interaction to using result.to_false()
func on_compare(node_a, node_b, result: BoolObject):
    var interactable_a = node_a as Interactable
    var interactable_b = node_b as Interactable

    if interactable_b != null && interactable_a != null:
        if interactable_a.inventory.have_item(item) == exceptedToHave:
            result.to_true()
        else:
            result.to_false()     
