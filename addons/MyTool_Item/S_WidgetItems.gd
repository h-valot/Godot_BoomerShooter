@tool
extends Control

@onready var tabBar: TabBar = $TabContainer/Weapons as TabBar
@onready var item_list: ItemList = $TabContainer/Weapons/WeaponList as ItemList
@onready var detail_panel: ItemList = $TabContainer/Weapons/WeaponDetailsList as ItemList
@onready var weapon_instance_template: HBoxContainer = $TabContainer/Weapons/WeaponList/ScrollContainer/VBoxContainer/HBoxContainer.duplicate()
@onready var weapon_list_container: VBoxContainer = $TabContainer/Weapons/WeaponList/ScrollContainer/VBoxContainer as VBoxContainer

var items_data: Dictionary = {
	"weapons": [],
	"consumables": [],
	"misc": []
}

func _ready() -> void:
	tabBar.connect("tab_changed", Callable(self, "_on_tab_changed"))
	item_list.connect("item_selected", Callable(self, "_on_item_selected"))
	_init_ui(tabBar.current_tab)
	_list_files_in_directory("res://Assets/Resources/Items/Weapons/")

func _init_ui(current_tab: int) -> void:
	_on_tab_changed(current_tab)

func _on_tab_changed(tab_index: int) -> void:
	item_list.clear()
	var category: String = tabBar.get_tab_title(tab_index).to_lower()
	if items_data.has(category):
		for item in items_data[category]:
			item_list.add_item(item.name)


func _generate_guid() -> int:
	return randi()

func _on_b_add_weapon_pressed() -> void:
	var weapon_config = WeaponConfig.new()
	weapon_config.GUID = _generate_guid()
	weapon_config.name = "Nouvelle Arme"
	if weapon_config.is_class("Resource") and weapon_config.name != "":
		var save_path = "res://Assets/Resources/Items/Weapons/"+ weapon_config.name + str(weapon_config.GUID) + ".tres"
		var error = ResourceSaver.save(weapon_config,save_path)
		var weapon_item_instance = weapon_instance_template.duplicate()
		if error != OK:
			print("Error saving the resource: ", error)
		else:
			print("Resource successfully saved to: ", save_path)
		weapon_item_instance.visible = true
		weapon_item_instance.get_node("B_ShowDetailsWeapon/L_NameWeapon").text = weapon_config.name
		weapon_list_container.add_child(weapon_item_instance)
	else:
		print("Error: Weapon configuration is invalid or incomplete.")

func _list_files_in_directory(directory_path: String):
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				_load_and_display_weapon_config(directory_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path: ", directory_path)

func _load_and_display_weapon_config(file_path: String):
	var weapon_config := ResourceLoader.load(file_path) as WeaponConfig
	if weapon_config:
		var weapon_item_instance = weapon_instance_template.duplicate()
		# add signal to ShowDetailWeapon Button
		weapon_item_instance.get_node("B_ShowDetailsWeapon").connect("pressed", _on_b_show_details_weapon_pressed.bind(weapon_config))
		weapon_item_instance.get_node("B_ShowDetailsWeapon/L_NameWeapon").text = weapon_config.name
		weapon_list_container.add_child(weapon_item_instance)
		weapon_item_instance.visible = true
		print("Loaded weapon config: ", weapon_config.name)
		
		
		# Configurer le bouton de suppression
		var delete_button = weapon_item_instance.get_node("B_DeleteWeapon")
		if delete_button:
			delete_button.connect("pressed", _on_b_delete_weapon_pressed.bind(weapon_config, weapon_item_instance, file_path))
	else:
		print("Failed to load weapon config from: ", file_path)

func _on_b_delete_weapon_pressed(weapon_config: WeaponConfig, weapon_item_instance: Node, file_path: String):
	# Show a confirmation dialog before deleting
	var confirmation_dialog = ConfirmationDialog.new()
	confirmation_dialog.dialog_text = "Are you sure you want to delete this weapon: " + weapon_config.name + "?"
	confirmation_dialog.connect("confirmed", _confirm_delete_weapon.bind(weapon_config, weapon_item_instance, file_path))
	add_child(confirmation_dialog)
	confirmation_dialog.popup_centered()

func _confirm_delete_weapon(weapon_config: WeaponConfig, weapon_item_instance: Node, file_path: String):
	# Delete UI instance
	weapon_item_instance.queue_free()
	# Delete File System Configuration File
	var dir = DirAccess.open("res://Assets/Resources/Items/Weapons/")
	if dir.remove(file_path) == OK:
		print("Weapon configuration file deleted successfully: ", file_path)
	else:
		print("Failed to delete weapon configuration file: ", file_path)
	items_data["weapons"].erase(weapon_config)




# Load all details of the Weapon Config
func _on_b_show_details_weapon_pressed(weapon_config: WeaponConfig):
	detail_panel.get_node("ScrollContainer/VBoxContainer/HBoxContainer_Name/TextEdit_Name").text = weapon_config.name
	print("Details shown for: ", weapon_config.name)
