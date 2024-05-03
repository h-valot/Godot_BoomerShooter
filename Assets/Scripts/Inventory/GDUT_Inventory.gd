extends GutTest

## Make test on [Inventory], [ItemConfig] and [InventoryInitializer]
class TestInventory:
	extends GutTest

	func test_inventory():
		var inventory = Inventory.new()
		inventory.ready.emit()

		var item = ItemConfig.new()
		item.name = "Item"
		item.stackable = true
		item.max_stack = 10

		var inventoryInitializer = InventoryInitializer.new()
		inventoryInitializer.inventory = inventory
		inventoryInitializer.items = {item: 5}

		inventoryInitializer._ready()

		assert_true(inventory.have_item(item), "Failed to detect if have item.")

		inventory.content.clear()

		inventory.add_item(item)
		assert_eq(inventory.get_item_quantity(item), 1, "Failed to add item.") 
		inventory.add_item(item)
		assert_eq(inventory.get_item_quantity(item), 2, "Failed to increment item quantity.")
		assert_true(inventory.have_item(item), "Failed to detect if have item.")

		inventory.set_item_quantity(item, 10)
		assert_eq(inventory.get_item_quantity(item), 10, "Failed to set item quantity.")
		
		inventory.set_item_quantity(item, 0)
		assert_false(inventory.have_item(item), "Failed to remove item.")
