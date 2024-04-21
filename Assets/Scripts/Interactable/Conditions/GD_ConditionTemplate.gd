extends InteractableCondition

# class_name ConditionMyConditionName

func _ready():
    OnCompare.connect(self.on_compare)

## Called when a comparaison happend,
## you can refuse the interaction to using result.to_false()
func on_compare(_node_a, _node_b, _result: BoolObject):
    pass
