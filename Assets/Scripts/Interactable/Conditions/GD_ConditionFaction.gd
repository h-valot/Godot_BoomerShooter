extends InteractableCondition

## Valid an interaction if both object have the same [InteractableFaction].
class_name ConditionFaction

func _ready():
    OnCompare.connect(self.on_compare)

## Called when a comparaison happend,
## you can refuse the interaction to using result.to_false()
func on_compare(node_a, node_b, result: BoolObject):
    var interactable_a: Interactable = node_a as Interactable
    var interactable_b: Interactable = node_b as Interactable
	  
    if (interactable_a == null || interactable_b == null):
        printerr("You called compare on two node that are not interactible")
        result.to_false()
	
    if (require_faction && interactable_a.interactable_faction.name != faction.name):
        result.to_false()
	    
    if (require_faction && interactable_b.interactable_faction.name != faction.name):
        result.to_false()
