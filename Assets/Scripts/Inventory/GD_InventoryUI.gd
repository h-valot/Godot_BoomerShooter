extends Node2D

@export var inventory: Inventory
@export var text_position: Vector2;
@export var text_side: Side;
@export var text_anchor: float;
@export var hide_quantity_when_one: bool;

func _ready():
	assert(inventory != null, "Missing inventory")

	_on_changed(null);
	
	inventory.on_set_item_quantity.connect(_on_changed);

func _on_changed(_item: ItemConfig):
	print("Size: " + str(inventory.content.size()))
	for child in $Container.get_children():
		$Container.remove_child(child);
		child.queue_free();
		
	for inventory_item in inventory.content:
		print("Item: " + inventory_item.name)
		var item_config = inventory_item as ItemConfig;
		if item_config != null:
			var textureRect = TextureRect.new();
			textureRect.texture = item_config.icon
			var quantity = inventory.content[inventory_item];
			if (hide_quantity_when_one && quantity > 1) || !hide_quantity_when_one:
				var text = Label.new();
				text.position = text_position;
				text.set_anchor(text_side, text_anchor);
				text.text = String.num_int64(quantity);
				textureRect.add_child(text);
			$Container.add_child(textureRect);
