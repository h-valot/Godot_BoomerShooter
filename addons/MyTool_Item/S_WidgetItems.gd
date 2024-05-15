@tool
extends Control


@onready var tab_container : TabContainer = $TabContainer as TabContainer

#region InitializeWeapon
@onready var weapon_instance_template_path

@onready var weapon_save_button : Button = $TabContainer/Weapons/WeaponDetailsList/Button_Save_weapon as Button


@onready var weapon_tabBar: TabBar = $TabContainer/Weapons as TabBar
@onready var weapon_item_list: ItemList = $TabContainer/Weapons/WeaponList as ItemList
@onready var weapon_instance_template: HBoxContainer 
@onready var weapon_list_container: VBoxContainer = $TabContainer/Weapons/WeaponList/ScrollContainer/VBoxContainer as VBoxContainer

@onready var weapon_name : TextEdit = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Name/TextEdit_Name as TextEdit
@onready var weapon_item_mesh : OptionButton = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_SelectItem/OptionButton_Mesh as OptionButton
@onready var icon_selector: OptionButton = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_IconWeapon/OptionButton_Icon as OptionButton
@onready var weapon_icon : TextureRect = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_IconWeapon/TextureRect_Icon as TextureRect
@onready var weapon_quantity : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Quantity/SpinBox_Quantity as SpinBox
@onready var weapon_max_stack : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_MaxStack/SpinBox_MaxStack as SpinBox
@onready var weapon_stackable : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Stackable/CheckBox_Stackable as CheckBox
@onready var weapon_switch_speed : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_SwitchSpeed/SpinBox_SwitchSpeed as SpinBox
@onready var weapon_mag_size : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_MagSize/SpinBox_MagSize as SpinBox
@onready var weapon_starting_mag_amount : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_StartingMagAmount/SpinBox_StartingMagAmount as SpinBox
@onready var weapon_reload_time : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_ReloadTime/SpinBox_ReloadTime as SpinBox
@onready var weapon_recoil_scalar : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_RecoilScalar/SpinBox_RecoilScalar as SpinBox
@onready var weapon_camera_shake_strength : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_RecoilScalar/SpinBox_RecoilScalar as SpinBox
@onready var weapon_camera_shake_fade : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_RecoilScalar/SpinBox_RecoilScalar as SpinBox
@onready var weapon_bullet_amount_per_shot : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Bullet_Amount_Per_Shot/SpinBox_Bullet_Amount_Per_Shot as SpinBox
@onready var weapon_spread : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Spread/SpinBox_Spread as SpinBox
@onready var weapon_raycast_lenght : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Bullet_Amount_Per_Shot/SpinBox_Bullet_Amount_Per_Shot as SpinBox
@onready var weapon_fire_rate : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_FireRate/SpinBox_FireRate as SpinBox
@onready var weapon_bullet_mesh : OptionButton = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletMesh/OptionButton_BulletMesh as OptionButton
@onready var weapon_hit_scan : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_HitScan/CheckBox_HitScan as CheckBox
@onready var weapon_interrupts_npc_attacks : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_InterruptsNpcAttacks/CheckBox_InterruptsNpcAttacks as CheckBox
@onready var weapon_bullet_damage : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletDamage/SpinBox_BulletDamage as SpinBox
@onready var weapon_bullet_start_speed : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletDamage/SpinBox_BulletDamage as SpinBox
@onready var weapon_bullet_lifetime : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletLifetime/SpinBox_BulletLifetime as SpinBox
@onready var weapon_bullet_gravity : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_BulletGravityScale/SpinBox_BulletGravityScale as SpinBox
@onready var weapon_create_zone_on_impact : CheckBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Create_Zone_On_Impact/CheckBox_Create_Zone_On_Impact as CheckBox
@onready var weapon_zone_radius : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Zone_Radius/SpinBox_Zone_Radius as SpinBox
@onready var weapon_zone_lifetime : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Zone_Lifetime/SpinBox_Zone_Lifetime as SpinBox
@onready var weapon_zone_damage_per_tick : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Zone_Damage_Per_Tick/SpinBox_Zone_Damage_Per_Tick as SpinBox
@onready var weapon_zone_tick_duration : SpinBox = $TabContainer/Weapons/WeaponDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Zone_Tick_Duration/SpinBox_Zone_Tick_Duration as SpinBox

#endregion
#region InitializeConsumable

@onready var consumable_instance_template_path

@onready var consumable_save_button : Button = $TabContainer/Consumables/ConsumableDetailsList/Button_Save_Consumable as Button

@onready var consumable_tabBar: TabBar = $TabContainer/Consumables as TabBar
@onready var consumable_item_list: ItemList = $TabContainer/Consumables/ConsumableList as ItemList
@onready var consumable_instance_template: HBoxContainer
@onready var consumable_list_container: VBoxContainer = $TabContainer/Consumables/ConsumableList/ScrollContainer/VBoxContainer as VBoxContainer

@onready var consumable_name : TextEdit = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Name/TextEdit_Name as TextEdit
@onready var consumable_item_mesh : OptionButton = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_SelectItem/OptionButton_Mesh as OptionButton
@onready var consumable_icon : TextureRect = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_IconWeapon/TextureRect_Icon as TextureRect
@onready var consumable_icon_selector: OptionButton = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_IconWeapon/OptionButton_Icon as OptionButton
@onready var consumable_quantity : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Quantity/SpinBox_Quantity as SpinBox
@onready var consumable_max_stack : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_MaxStack/SpinBox_MaxStack as SpinBox
@onready var consumable_stackable : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Stackable/CheckBox_Stackable as CheckBox
@onready var consumable_use_heal_damage : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Heal_Damage/CheckBox_Heal_Damage as CheckBox
@onready var consumable_heal_damage : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Heal_Damage/SpinBox_Heal_Damage as SpinBox
@onready var consumable_use_armor : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Armor/CheckBox_Armor as CheckBox
@onready var consumable_armor: SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Armor/SpinBox_Armor as SpinBox
@onready var consumable_use_stun_duration : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Stun_Duration/CheckBox_Stun_Duration as CheckBox
@onready var consumable_stun_duration : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Stun_Duration/SpinBox_Stun_Duration as SpinBox
@onready var consumable_use_speed_boost : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Speed_Boost/CheckBox_Speed_Boost as CheckBox
@onready var consumable_speed_boost : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Speed_Boost/SpinBox_Speed_Boost as SpinBox
@onready var consumable_use_invisibility_duration : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Invisibility_Duration/CheckBox_Invisibility_Duration as CheckBox
@onready var consumable_invisibility_duration : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Invisibility_Duration/SpinBox_Invisibility_Duration as SpinBox
@onready var consumable_use_jump_force_boost : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Jump_Force_Boost/CheckBox_Jump_Force_Boost as CheckBox
@onready var consumable_jump_force_boost : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Jump_Force_Boost/SpinBox_Jump_Force_Boost as SpinBox
@onready var consumable_use_damage_boost: CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Damage_Boost/CheckBox_Damage_Boost as CheckBox
@onready var consumable_damage_boost : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Damage_Boost/SpinBox_Damage_Boost as SpinBox
@onready var consumable_use_speed : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Speed/CheckBox_Speed as CheckBox
@onready var consumable_speed : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Speed/SpinBox_Speed as SpinBox
@onready var consumable_use_trajectory : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Trajectory/CheckBox_Trajectory as CheckBox
@onready var consumable_trajectory : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Trajectory/SpinBox_Trajectory as SpinBox
@onready var consumable_use_Lifetime : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Lifetime/CheckBox_Lifetime as CheckBox
@onready var consumable_Lifetime : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Lifetime/SpinBox_Lifetime as SpinBox
@onready var consumable_use_impact_size : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Impact_Size/CheckBox_Impact_Size as CheckBox
@onready var consumable_impact_size : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Impact_Size/SpinBox_Impact_Size as SpinBox
@onready var consumable_use_range : CheckBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Range/CheckBox_Range as CheckBox
@onready var consumable_range : SpinBox = $TabContainer/Consumables/ConsumableDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Range/SpinBox_Range as SpinBox

#endregion


var items_data: Dictionary = {
	"weapons": [],
	"consumables": [],
	"misc": []
}

func _generate_guid() -> int:
	return randi()
	
func get_all_images_in_project(directory_path="res://"):
	var image_paths = []
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png") or file_name.ends_with(".jpg") or file_name.ends_with(".svg"):
				image_paths.append(directory_path + file_name)
			elif dir.current_is_dir():
				image_paths += get_all_images_in_project(directory_path + file_name + "/")
			file_name = dir.get_next()
		dir.list_dir_end()
	return image_paths
	
func get_all_meshes_in_project(directory_path="res://"):
	var mesh_paths = []
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				mesh_paths.append(directory_path + file_name)
			elif dir.current_is_dir():
				mesh_paths += get_all_meshes_in_project(directory_path + file_name + "/")
			file_name = dir.get_next()
		dir.list_dir_end()
	return mesh_paths

func _ready() -> void:
	_check_weapon_instance_template_exist()
	_check_consumable_instance_template_exist()
	
	weapon_item_mesh.connect("item_selected", _on_mesh_selected)
	icon_selector.connect("item_selected", _on_image_selected)
	weapon_bullet_mesh.connect("item_selected", _on_bullet_mesh_selected)
	consumable_item_mesh.connect("item_selected", _on_consumable_mesh_selected)
	consumable_icon_selector.connect("item_selected", _on_consumable_image_selected)
	populate_images()
	populate_weapon_meshes()
	populate_bullet_meshes()
	populate_consumable_meshes()
	populate_consumable_images()
	
	
	tab_container.connect("tab_changed", Callable(self, "_on_tab_changed"))
	weapon_item_list.connect("item_selected", Callable(self, "_on_item_selected"))
	_list_weapons_files_in_directory("res://Assets/Resources/Items/Weapons/")
	_list_consumable_files_in_directory("res://Assets/Resources/Items/Consumables/")
	_init_ui(tab_container.current_tab)
	

func _on_mesh_selected(index: int):
	var mesh_path = weapon_item_mesh.get_item_text(index)

func populate_weapon_meshes():
	weapon_item_mesh.clear()
	var meshes = get_all_meshes_in_project()
	weapon_item_mesh.add_item("NONE")
	for mesh_path in meshes:
		print(mesh_path)
		weapon_item_mesh.add_item(mesh_path)

func populate_bullet_meshes():
	weapon_bullet_mesh.clear()
	var meshes = get_all_meshes_in_project()
	weapon_bullet_mesh.add_item("NONE")
	for mesh_path in meshes:
		print(mesh_path)
		weapon_bullet_mesh.add_item(mesh_path)

func populate_consumable_meshes():
	consumable_item_mesh.clear()
	var meshes = get_all_meshes_in_project()
	consumable_item_mesh.add_item("NONE")
	for mesh_path in meshes:
		print(mesh_path)
		consumable_item_mesh.add_item(mesh_path)

func populate_images():
	icon_selector.clear()
	icon_selector.add_item("NONE")
	var images = get_all_images_in_project()
	for image_path in images:
		var texture = load(image_path)
		if texture:
			icon_selector.add_icon_item(texture, image_path.get_file())
			icon_selector.set_item_metadata(icon_selector.get_item_count() - 1, image_path)

func populate_consumable_images():
	consumable_icon_selector.clear()
	consumable_icon_selector.add_item("NONE")
	var images = get_all_images_in_project()
	for image_path in images:
		var texture = load(image_path)
		if texture:
			consumable_icon_selector.add_icon_item(texture, image_path.get_file())
			consumable_icon_selector.set_item_metadata(consumable_icon_selector.get_item_count() - 1, image_path)

func _on_image_selected(index: int):
	var selected_image_path = consumable_icon_selector.get_item_metadata(index)
	if consumable_icon_selector.get_item_text(index) == "NONE":
		consumable_icon_selector.icon = null
		print("No icon selected.")
	else:
		var texture = load(selected_image_path)
		consumable_icon_selector.icon = texture
		print("Selected image: ", selected_image_path)


func _on_consumable_image_selected(index: int):
	var selected_image_path = icon_selector.get_item_metadata(index)
	if icon_selector.get_item_text(index) == "NONE":
		icon_selector.icon = null
		print("No icon selected.")
	else:
		var texture = load(selected_image_path)
		icon_selector.icon = texture
		print("Selected image: ", selected_image_path)


func _on_bullet_mesh_selected(index: int):
	var mesh_path = weapon_bullet_mesh.get_item_text(index)
	print("Selected bullet mesh: ", mesh_path)

func _on_consumable_mesh_selected(index: int):
	var mesh_path = weapon_bullet_mesh.get_item_text(index)
	print("Selected consumable mesh: ", mesh_path)

func _check_weapon_instance_template_exist():
	if not weapon_instance_template:
		weapon_instance_template_path = preload("res://addons/MyTool_Item/h_box_weapon_container.tscn")
		weapon_instance_template = weapon_instance_template_path.instantiate()
	if not weapon_instance_template:
		print("Critical error: Unable to load weapon instance template.")
		return

func _init_ui(current_tab: int) -> void:
	_on_tab_changed(current_tab)

func _on_tab_changed(tab_index: int) -> void:
	var current_tab_title = tab_container.get_tab_title(tab_index).to_lower()
	print("current tab title : " + current_tab_title)
	match current_tab_title:
		"weapons":
			weapon_tabBar.visible = true
			consumable_tabBar.visible = false
		"consumables":
			consumable_tabBar.visible = true
			weapon_tabBar.visible = false

func _initialize_weapon_item_instance(weapon_config: WeaponConfig, file_path: String):
	var weapon_item_instance = weapon_instance_template.duplicate()
	if not weapon_item_instance:
		print("Failed to load weapon instance template from: ", weapon_instance_template_path)
		return
	weapon_item_instance.visible = true
	weapon_item_instance.get_node("B_ShowDetailsWeapon/L_NameWeapon").text = weapon_config.name
	weapon_item_instance.get_node("B_ShowDetailsWeapon").connect("pressed", _on_b_show_details_weapon_pressed.bind(weapon_config))
		
	var delete_button = weapon_item_instance.get_node("B_DeleteWeapon")
	if delete_button:
		delete_button.connect("pressed", _on_b_delete_weapon_pressed.bind(weapon_config, weapon_item_instance, file_path))
	weapon_list_container.add_child(weapon_item_instance)

func _on_b_add_weapon_pressed() -> void:
	var weapon_config = WeaponConfig.new()
	weapon_config.GUID = _generate_guid()
	weapon_config.name = "New Weapon"
	if weapon_config.is_class("Resource") and weapon_config.name != "":
		var save_path = "res://Assets/Resources/Items/Weapons/"+ weapon_config.name + str(weapon_config.GUID) + ".tres"
		var error = ResourceSaver.save(weapon_config,save_path)
		if error != OK:
			print("Error saving the resource: ", error)
		else:
			print("Resource successfully saved to: ", save_path)
		
		_initialize_weapon_item_instance(weapon_config, save_path)
		_list_weapons_files_in_directory("res://Assets/Resources/Items/Weapons/")
	else:
		print("Error: Weapon configuration is invalid or incomplete.")

func _clear_weapon_list():
	for child in weapon_list_container.get_children():
		child.queue_free()


func _list_weapons_files_in_directory(directory_path: String):
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
	print("file path " + file_path)
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
	
	
func _on_save_weapon_config_button_pressed(weapon_config: WeaponConfig):
	var is_renamed = false
	var old_name = weapon_config.name
	var new_name = weapon_name.text
	if old_name != new_name:
		var old_path = "res://Assets/Resources/Items/Weapons/" + old_name + str(weapon_config.GUID) + ".tres"
		var new_path = "res://Assets/Resources/Items/Weapons/" + new_name + str(weapon_config.GUID) + ".tres"
		# Rename the file
		var dir = DirAccess.open("res://Assets/Resources/Items/Weapons/")
		if dir.file_exists(old_path):
			var error_rename = dir.rename(old_path, new_path)
			if error_rename != OK:
				print("Failed to rename file: ", dir.get_last_error())
				return
			else:
				print("RENAME GOOD")
				is_renamed = true
				
		else:
			print("Old file does not exist, no need to rename.")
	# Update Weapon Config
	update_weapon_config(weapon_config)
	# Save the configuration of the weapon
	var file_path = "res://Assets/Resources/Items/Weapons/" + weapon_config.name + str(weapon_config.GUID) + ".tres"
	var error_save = ResourceSaver.save(weapon_config, file_path)
	if error_save != OK:
		print("Error saving the resource: ", error_save)
	else:
		print("Resource successfully saved to: ", file_path)
	if(is_renamed):
		_list_weapons_files_in_directory("res://Assets/Resources/Items/Weapons/")
		EditorInterface.get_resource_filesystem().scan()
		is_renamed = false




func update_weapon_config(weapon_config: WeaponConfig):
	weapon_config.name = weapon_name.text 
	var item_mesh_path = weapon_item_mesh.get_item_text(weapon_item_mesh.get_selected_id())
	var bullet_mesh_path = weapon_bullet_mesh.get_item_text(weapon_bullet_mesh.get_selected_id())
	if item_mesh_path != "NONE":
		weapon_config.item_mesh = load(item_mesh_path) as PackedScene
	else:
		weapon_config.item_mesh = null
	if bullet_mesh_path != "NONE":
		weapon_config.bullet_mesh = load(bullet_mesh_path) as PackedScene
	else:
		weapon_config.bullet_mesh = null
	weapon_config.icon = icon_selector.icon 
	weapon_config.quantity = weapon_quantity.value 
	weapon_config.max_stack = weapon_max_stack.value 
	weapon_config.stackable = weapon_stackable.button_pressed
	weapon_config.switch_speed = weapon_switch_speed.value 
	weapon_config.mag_size = weapon_mag_size.value 
	weapon_config.starting_mag_amount = weapon_starting_mag_amount.value 
	weapon_config.reload_time = weapon_reload_time.value 
	weapon_config.recoil_scalar = weapon_recoil_scalar.value 
	#weapon_config.recoil_curve = weapon_scalar.value 
	weapon_config.camera_shake_strength = weapon_camera_shake_strength.value
	weapon_config.camera_shake_fade = weapon_camera_shake_fade.value
	weapon_config.bullet_amount_per_shot = weapon_bullet_amount_per_shot.value 
	weapon_config.spread = weapon_spread.value 
	weapon_config.raycast_length = weapon_raycast_lenght.value
	weapon_config.fire_rate = weapon_fire_rate.value 
	#weapon_bullet_mesh
	weapon_config.hit_scan = weapon_hit_scan.button_pressed 
	weapon_config.interrupts_npc_attack = weapon_interrupts_npc_attacks.button_pressed 
	weapon_config.bullet_damage = weapon_bullet_damage.value 
	weapon_config.bullet_start_speed = weapon_bullet_start_speed.value
	weapon_config.bullet_lifetime = weapon_bullet_lifetime.value 
	weapon_config.bullet_gravity_scale = weapon_bullet_gravity.value 
	weapon_config.create_zone_on_impact = weapon_create_zone_on_impact.button_pressed
	weapon_config.zone_radius = weapon_zone_radius.value
	weapon_config.zone_lifetime = weapon_zone_lifetime.value
	weapon_config.zone_damage_per_tick = weapon_zone_tick_duration.value
	weapon_config.zone_tick_duration = weapon_zone_tick_duration.value
	
	

# Load all details of the Weapon Config
func _on_b_show_details_weapon_pressed(weapon_config: WeaponConfig):
	if(weapon_save_button.is_connected("pressed", _on_save_weapon_config_button_pressed.bind(weapon_config))):
		weapon_save_button.disconnect("pressed", _on_save_weapon_config_button_pressed.bind(weapon_config))
	weapon_save_button.connect("pressed", _on_save_weapon_config_button_pressed.bind(weapon_config))
	weapon_name.text = weapon_config.name
	
	if weapon_config.item_mesh != null:
		var item_mesh_path = weapon_config.item_mesh.resource_path
		for i in range(weapon_item_mesh.get_item_count()):
			if weapon_item_mesh.get_item_text(i) == item_mesh_path:
				weapon_item_mesh.select(i)
				break
	else:
		weapon_item_mesh.select(0)

	if weapon_config.bullet_mesh != null:
		var bullet_mesh_path = weapon_config.bullet_mesh.resource_path
		for i in range(weapon_bullet_mesh.get_item_count()):
			if weapon_bullet_mesh.get_item_text(i) == bullet_mesh_path:
				weapon_bullet_mesh.select(i)
				break
	else:
		weapon_bullet_mesh.select(0)
		
	weapon_quantity.value = weapon_config.quantity
	weapon_max_stack.value = weapon_config.max_stack
	weapon_stackable.button_pressed = weapon_config.stackable
	weapon_switch_speed.value = weapon_config.switch_speed
	weapon_mag_size.value = weapon_config.mag_size
	weapon_starting_mag_amount.value = weapon_config.starting_mag_amount
	weapon_reload_time.value = weapon_config.reload_time
	weapon_recoil_scalar.value = weapon_config.recoil_scalar
	#weapon_scalar.value = weapon_config.recoil_curve
	weapon_camera_shake_strength.value = weapon_config.camera_shake_strength 
	weapon_camera_shake_fade.value = weapon_config.camera_shake_fade 
	weapon_bullet_amount_per_shot.value = weapon_config.bullet_amount_per_shot
	weapon_spread.value = weapon_config.spread
	weapon_raycast_lenght.value = weapon_config.raycast_length
	weapon_fire_rate.value = weapon_config.fire_rate
	weapon_hit_scan.button_pressed = weapon_config.hit_scan
	weapon_interrupts_npc_attacks.button_pressed = weapon_config.interrupts_npc_attack
	weapon_bullet_damage.value = weapon_config.bullet_damage
	weapon_bullet_start_speed.value = weapon_config.bullet_start_speed
	weapon_bullet_lifetime.value = weapon_config.bullet_lifetime
	weapon_bullet_gravity.value = weapon_config.bullet_gravity_scale

	weapon_create_zone_on_impact.button_pressed = weapon_config.create_zone_on_impact
	weapon_zone_radius.value = weapon_config.zone_radius
	weapon_zone_lifetime.value = weapon_config.zone_lifetime
	weapon_zone_tick_duration.value = weapon_config.zone_damage_per_tick
	weapon_zone_tick_duration.value = weapon_config.zone_tick_duration
	print("Details shown for: ", weapon_config.name)
	if weapon_config and weapon_config.icon and weapon_config.icon is Texture:
		var weapon_icon_path = weapon_config.icon.resource_path
		for i in range(icon_selector.get_item_count()):
			var metadata = icon_selector.get_item_metadata(i)
			if metadata and metadata == weapon_icon_path:
				icon_selector.selected = i
				return
	icon_selector.selected = 0


func _check_consumable_instance_template_exist():
	if not consumable_instance_template:
		consumable_instance_template_path = preload("res://addons/MyTool_Item/h_box_consumable_container.tscn")
		consumable_instance_template = consumable_instance_template_path.instantiate()
	if not weapon_instance_template:
		print("Critical error: Unable to load weapon instance template.")
		return

func _initialize_consumable_item_instance(consumable_config: ConsumableConfig, file_path: String):
	var consumable_item_instance = consumable_instance_template.duplicate()
	consumable_item_instance.visible = true
	consumable_item_instance.get_node("B_ShowDetailsConsumable/L_NameConsumable").text = consumable_config.name
	consumable_item_instance.get_node("B_ShowDetailsConsumable").connect("pressed", _on_b_show_details_consumable_pressed.bind(consumable_config))
	
	var delete_button = consumable_item_instance.get_node("B_DeleteConsumable")
	if delete_button:
		delete_button.connect("pressed", _on_b_delete_consumable_pressed.bind(consumable_config, consumable_item_instance, file_path))
	consumable_list_container.add_child(consumable_item_instance)

func _on_b_add_consumable_pressed():
	var consumable_config = ConsumableConfig.new()
	consumable_config.GUID = _generate_guid()
	consumable_config.name = "New Consumable"
	if consumable_config.is_class("Resource") and consumable_config.name != "":
		var save_path = "res://Assets/Resources/Items/Consumables/"+ consumable_config.name + str(consumable_config.GUID) + ".tres"
		var error = ResourceSaver.save(consumable_config,save_path)
		
		if error != OK:
			print("Error saving the resource: ", error)
		else:
			print("Resource successfully saved to: ", save_path)
		
		_initialize_consumable_item_instance(consumable_config, save_path)
		_list_consumable_files_in_directory("res://Assets/Resources/Items/Consumables/")
	else:
		print("Error: Consumable configuration is invalid or incomplete.")


func _on_b_delete_consumable_pressed(consumable_config: ConsumableConfig, consumable_item_instance: Node, file_path: String):
	# Show a confirmation dialog before deleting
	var confirmation_dialog = ConfirmationDialog.new()
	confirmation_dialog.dialog_text = "Are you sure you want to delete this consumable: " + consumable_config.name + "?"
	confirmation_dialog.connect("confirmed", _confirm_delete_consumable.bind(consumable_config, consumable_item_instance, file_path))
	add_child(confirmation_dialog)
	confirmation_dialog.popup_centered()


func _confirm_delete_consumable(consumable_config: ConsumableConfig, consumable_item_instance: Node, file_path: String):
	# Delete UI instance
	consumable_item_instance.queue_free()
	# Delete File System Configuration File
	var dir = DirAccess.open("res://Assets/Resources/Items/Consumables/")
	if dir.remove(file_path) == OK:
		print("Consumable configuration file deleted successfully: ", file_path)
		EditorInterface.get_resource_filesystem().scan()
	else:
		print("Failed to delete consumable configuration file: ", file_path)
	items_data["consumables"].erase(consumable_config)


func _clear_consumable_list():
	for child in consumable_list_container.get_children():
		child.queue_free()

func _list_consumable_files_in_directory(directory_path: String):
	_clear_consumable_list()
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				_load_and_display_consumable_config(directory_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path: ", directory_path)

func _load_and_display_consumable_config(file_path: String):
	var consumable_config := ResourceLoader.load(file_path) as ConsumableConfig
	if consumable_config:
		_initialize_consumable_item_instance(consumable_config, file_path)
		print("Loaded consumable config: ", consumable_config.name)
	else:
		print("Failed to load consumable config from: ", file_path)


func _on_save_consumable_config_button_pressed(consumable_config: ConsumableConfig):
	var is_renamed = false
	var old_name = consumable_config.name
	var new_name = consumable_name.text
	if old_name != new_name:
		var old_path = "res://Assets/Resources/Items/Consumables/" + old_name + str(consumable_config.GUID) + ".tres"
		var new_path = "res://Assets/Resources/Items/Consumables/" + new_name + str(consumable_config.GUID) + ".tres"
		# Rename the file
		var dir = DirAccess.open("res://Assets/Resources/Items/Consumables/")
		if dir.file_exists(old_path):
			var error_rename = dir.rename(old_path, new_path)
			if error_rename != OK:
				print("Failed to rename file: ", dir.get_last_error())
				return
			else:
				print("RENAME GOOD")
				is_renamed = true
		else:
			print("Old file does not exist, no need to rename.")
			
			
	# Update Consumable Config
	update_consumable_config(consumable_config)
	var file_path = "res://Assets/Resources/Items/Consumables/" + consumable_config.name + str(consumable_config.GUID) + ".tres"
	var error_save = ResourceSaver.save(consumable_config, file_path)
	if error_save != OK:
		print("Error saving the resource: ", error_save)
	else:
		print("Resource successfully saved to: ", file_path)
	if(is_renamed):
		_list_consumable_files_in_directory("res://Assets/Resources/Items/Consumables/")
		EditorInterface.get_resource_filesystem().scan()
		is_renamed = false


func _on_b_show_details_consumable_pressed(consumable_config : ConsumableConfig):
	if(consumable_save_button.is_connected("pressed", _on_save_consumable_config_button_pressed.bind(consumable_config))):
		consumable_save_button.disconnect("pressed", _on_save_consumable_config_button_pressed.bind(consumable_config))
	consumable_save_button.connect("pressed", _on_save_consumable_config_button_pressed.bind(consumable_config))
	consumable_name.text = consumable_config.name
	if consumable_config.item_mesh != null:
		var item_mesh_path = consumable_config.item_mesh.resource_path
		for i in range(consumable_item_mesh.get_item_count()):
			if consumable_item_mesh.get_item_text(i) == item_mesh_path:
				consumable_item_mesh.select(i)
				break
	else:
		consumable_item_mesh.select(0)
	consumable_quantity.value = consumable_config.quantity
	consumable_max_stack.value = consumable_config.max_stack
	consumable_stackable.button_pressed = consumable_config.stackable
	consumable_use_heal_damage.button_pressed = consumable_config.use_heal_damage
	consumable_heal_damage.value = consumable_config.heal_damage
	consumable_use_armor.button_pressed = consumable_config.use_armor
	consumable_armor.value = consumable_config.armor
	consumable_use_stun_duration.button_pressed = consumable_config.use_stun_duration
	consumable_stun_duration.value = consumable_config.stun_duration
	consumable_use_speed_boost.button_pressed = consumable_config.use_speed_boost
	consumable_speed_boost.value = consumable_config.speed_boost
	consumable_use_invisibility_duration.button_pressed = consumable_config.use_invisibility_duration
	consumable_invisibility_duration.value = consumable_config.invisibility_duration
	consumable_use_jump_force_boost.button_pressed = consumable_config.use_jump_force_boost
	consumable_jump_force_boost.value = consumable_config.jump_force_boost
	consumable_use_damage_boost.button_pressed = consumable_config.use_damage_boost
	consumable_damage_boost.value = consumable_config.damage_boost
	consumable_use_speed.button_pressed = consumable_config.use_speed
	consumable_speed.value = consumable_config.speeed
	consumable_use_trajectory.button_pressed = consumable_config.use_trajectory
	consumable_trajectory.value = consumable_config.trajectory
	consumable_use_Lifetime.button_pressed = consumable_config.use_lifetime
	consumable_Lifetime.value = consumable_config.lifetime
	consumable_use_impact_size.button_pressed = consumable_config.use_impact_size
	consumable_impact_size.value = consumable_config.impact_size
	consumable_use_range.button_pressed = consumable_config.use_range
	consumable_range.value = consumable_config.throw_range
	if consumable_config.icon and consumable_config.icon is Texture2D:
		var consumable_icon_path = consumable_config.icon.resource_path
		for i in range(consumable_icon_selector.get_item_count()):
			var metadata = consumable_icon_selector.get_item_metadata(i)
			if metadata and metadata == consumable_icon_path:
				consumable_icon_selector.selected = i
				return
	consumable_icon_selector.selected = 0

func update_consumable_config(consumable_config: ConsumableConfig):
	consumable_config.name = consumable_name.text
	var consumable_mesh_path = consumable_item_mesh.get_item_text(consumable_item_mesh.get_selected_id())
	if consumable_mesh_path != "NONE":
		consumable_config.item_mesh = load(consumable_mesh_path) as PackedScene
	else:
		consumable_config.item_mesh = null
	consumable_config.icon = consumable_icon_selector.icon 
	consumable_config.quantity = consumable_quantity.value
	consumable_config.max_stack = consumable_max_stack.value 
	consumable_config.stackable = consumable_stackable.button_pressed
	consumable_config.use_heal_damage = consumable_use_heal_damage.button_pressed
	consumable_config.heal_damage = consumable_heal_damage.value
	consumable_config.use_armor = consumable_use_armor.button_pressed
	consumable_config.armor = consumable_armor.value
	consumable_use_stun_duration.button_pressed = consumable_config.use_stun_duration
	consumable_config.stun_duration = consumable_stun_duration.value
	consumable_config.use_speed_boost = consumable_use_speed_boost.button_pressed
	consumable_config.speed_boost = consumable_speed_boost.value
	consumable_config.use_invisibility_duration = consumable_use_invisibility_duration.button_pressed
	consumable_config.invisibility_duration = consumable_invisibility_duration.value
	consumable_config.use_jump_force_boost = consumable_use_jump_force_boost.button_pressed
	consumable_config.jump_force_boost = consumable_jump_force_boost.value
	consumable_config.use_damage_boost = consumable_use_damage_boost.button_pressed
	consumable_config.damage_boost = consumable_damage_boost.value
	consumable_config.use_speed = consumable_use_speed.button_pressed
	consumable_config.speeed = consumable_speed.value 
	consumable_config.use_trajectory = consumable_use_trajectory.button_pressed
	consumable_config.trajectory = consumable_trajectory.value
	consumable_config.use_lifetime = consumable_use_Lifetime.button_pressed
	consumable_config.lifetime = consumable_Lifetime.value
	consumable_config.use_impact_size = consumable_use_impact_size.button_pressed
	consumable_config.impact_size = consumable_impact_size.value 
	consumable_config.use_range = consumable_use_range.button_pressed
	consumable_config.throw_range = consumable_range.value


