@tool
extends Control

@onready var tabBar: TabBar = $TabContainer/Weapons as TabBar
@onready var item_list: ItemList = $TabContainer/Weapons/WeaponList as ItemList
@onready var detail_panel: ItemList = $TabContainer/Weapons/WeaponDetailsList as ItemList
@onready var weapon_instance_template: HBoxContainer = $TabContainer/Weapons/WeaponList/ScrollContainer/VBoxContainer/HBoxContainer.duplicate()
@onready var weapon_list_container: VBoxContainer = $TabContainer/Weapons/WeaponList/ScrollContainer/VBoxContainer as VBoxContainer



@onready var weapon_name : TextEdit = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Name/TextEdit_Name as TextEdit
@onready var weapon_item_mesh : OptionButton = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_SelectItem/OptionButton_Mesh as OptionButton
@onready var weapon_icon : TextureRect = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_IconWeapon/TextureRect_Icon as TextureRect
@onready var weapon_quantity : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Quantity/SpinBox_Quantity as SpinBox
@onready var weapon_max_stack : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_MaxStack/SpinBox_MaxStack as SpinBox
@onready var weapon_stackable : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Stackable/CheckBox_Stackable as CheckBox
@onready var weapon_switch_speed : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_SwitchSpeed/SpinBox_SwitchSpeed as SpinBox
@onready var weapon_mag_size : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_MagSize/SpinBox_MagSize as SpinBox
@onready var weapon_starting_mag_amount : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_StartingMagAmount/SpinBox_StartingMagAmount as SpinBox
@onready var weapon_reload_time : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_ReloadTime/SpinBox_ReloadTime as SpinBox
@onready var weapon_recoil_strength : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_RecoilStrength/SpinBox_RecoilStrength as SpinBox
@onready var weapon_bullet_amount_per_shot : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Bullet_Amount_Per_Shot/SpinBox_Bullet_Amount_Per_Shot as SpinBox
@onready var weapon_spread : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Spread/SpinBox_Spread as SpinBox
@onready var weapon_fire_rate : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_FireRate/SpinBox_FireRate as SpinBox
@onready var weapon_bullet_mesh : OptionButton = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletMesh/OptionButton_BulletMesh as OptionButton
@onready var weapon_hit_scan : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_HitScan/CheckBox_HitScan as CheckBox
@onready var weapon_interrupts_npc_attacks : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_InterruptsNpcAttacks/CheckBox_InterruptsNpcAttacks as CheckBox
@onready var weapon_bullet_damage : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletDamage/SpinBox_BulletDamage as SpinBox
@onready var weapon_bullet_life : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletLifetime/SpinBox_BulletLifetime as SpinBox
@onready var weapon_bullet_gravity : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletGravityScale/SpinBox_BulletGravityScale as SpinBox
@onready var weapon_impact_size : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_ImpactSize/SpinBox_ImpactSize as SpinBox


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
		
		if error != OK:
			print("Error saving the resource: ", error)
		else:
			print("Resource successfully saved to: ", save_path)
		
		_initialize_weapon_item_instance(weapon_config, save_path)
		_list_files_in_directory("res://Assets/Resources/Items/Weapons/")
	else:
		print("Error: Weapon configuration is invalid or incomplete.")

func _initialize_weapon_item_instance(weapon_config: WeaponConfig, file_path: String):
	var weapon_item_instance = weapon_instance_template.duplicate()
	weapon_item_instance.visible = true
	weapon_item_instance.get_node("B_ShowDetailsWeapon/L_NameWeapon").text = weapon_config.name
	weapon_item_instance.get_node("B_ShowDetailsWeapon").connect("pressed", _on_b_show_details_weapon_pressed.bind(weapon_config))
		
		# Configurer le bouton de suppression
	var delete_button = weapon_item_instance.get_node("B_DeleteWeapon")
	if delete_button:
		delete_button.connect("pressed", _on_b_delete_weapon_pressed.bind(weapon_config, weapon_item_instance, file_path))
	weapon_list_container.add_child(weapon_item_instance)


func _clear_weapon_list():
	for child in weapon_list_container.get_children():
		child.queue_free()
		
		
func _list_files_in_directory(directory_path: String):
	_clear_weapon_list()
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
		_initialize_weapon_item_instance(weapon_config, file_path)
		print("Loaded weapon config: ", weapon_config.name)
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
		EditorInterface.get_resource_filesystem().scan()
	else:
		print("Failed to delete weapon configuration file: ", file_path)
	items_data["weapons"].erase(weapon_config)


# Load all details of the Weapon Config
func _on_b_show_details_weapon_pressed(weapon_config: WeaponConfig):
	weapon_name.text = weapon_config.name
	#weapon_item_mesh
	#weapon_icon.texture = weapon_config.icon
	weapon_quantity.value = weapon_config.quantity
	weapon_max_stack.value = weapon_config.max_stack
	weapon_stackable.button_pressed = weapon_config.stackable
	weapon_switch_speed.value = weapon_config.switch_speed
	weapon_mag_size.value = weapon_config.mag_size
	weapon_starting_mag_amount.value = weapon_config.starting_mag_amount
	weapon_reload_time.value = weapon_config.reload_time
	weapon_recoil_strength.value = weapon_config.recoil_strength
	weapon_bullet_amount_per_shot.value = weapon_config.bullet_amount_per_shot
	weapon_spread.value = weapon_config.spread
	weapon_fire_rate.value = weapon_config.fire_rate
	#weapon_bullet_mesh
	weapon_hit_scan.button_pressed = weapon_config.hit_scan
	weapon_interrupts_npc_attacks.button_pressed = weapon_config.interrupts_npc_attack
	weapon_bullet_damage.value = weapon_config.bullet_damage
	weapon_bullet_life.value = weapon_config.bullet_lifetime
	weapon_bullet_gravity.value = weapon_config.bullet_gravity_scale
	weapon_impact_size.value = weapon_config.impact_size
	print("Details shown for: ", weapon_config.name)
