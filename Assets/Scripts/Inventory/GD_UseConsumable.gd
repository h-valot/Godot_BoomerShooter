extends Node

class_name UseConsumable

@export var oponentParentNode: Node

@export var health: HealthComponent
@export var player: Player

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func use_consumable(consumable: ConsumableConfig):
    if consumable.use_heal_damage:
        health.update_current_health(consumable.heal_damage)
    if consumable.use_armor:
        health.add_armor(consumable.armor)
    if consumable.use_stun_duration:
        pass
    if consumable.use_invisibility_duration:
        for opponent in InventoryUtils.get_childs_of_type(get_tree().current_scene, typeof(Opponent)):
            pass
        print("Begin invisibility")
        await get_tree().create_timer(consumable.invisibility_duration).timeout
        print("End invisibility")
        for opponent in InventoryUtils.get_childs_of_type(get_tree().current_scene, typeof(Opponent)):
            pass

func launch_consumable():
    pass
