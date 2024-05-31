extends Inventory

class_name WeaponInventory

@export var main_inventory: Inventory = null

func _ready():
    assert(main_inventory != null, "Missing main inventory")

    main_inventory.on_set_item_quantity.connect(_main_inventory_on_set_item_quantity)

func _main_inventory_on_set_item_quantity(item: ItemConfig):
    if item != null && (item as WeaponConfig) != null:
        set_item_quantity(item, main_inventory.get_item_quantity(item))
