
extends Control

@onready var tabBar: TabBar = $TabContainer/Weapons as TabBar
@onready var item_list: ItemList = $TabContainer/Weapons/ItemList as ItemList
@onready var detail_panel: Panel = $TabContainer/Weapons/Panel as Panel

var items_data: Dictionary = {
	"weapons": [],
	"consumables": [],
	"misc": []
}

func _ready() -> void:
	tabBar.connect("tab_changed", Callable(self, "_on_tab_changed"))
	item_list.connect("item_selected", Callable(self, "_on_item_selected"))

	# Initialize UI with the default or previously selected tab.
	_init_ui(tabBar.current_tab)

func _init_ui(current_tab: int) -> void:
	# Update the item list based on the currently selected tab.
	_on_tab_changed(current_tab)

func _on_tab_changed(tab_index: int) -> void:
	# Clear the current list.
	item_list.clear()

	# Get the title of the current tab to determine the category.
	var category: String = tabBar.get_tab_title(tab_index).to_lower()
	
	# Update the list with items from the selected category.
	if items_data.has(category):
		for item in items_data[category]:
			item_list.add_item(item.name)

func _on_item_selected(index: int) -> void:
	# Logic for when an item is selected from the list.
	pass

