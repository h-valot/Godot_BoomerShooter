@tool
extends Control

@onready var tab_container : TabContainer = $TabContainer as TabContainer


#region InitializeWeapon

@onready var player_save_button : Button = $TabContainer/Player/Button_Save as Button

@onready var player_tabBar : TabBar = $TabContainer/Player as TabBar

@onready var player_base_health : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Base_Health/SpinBox_Base_Health as SpinBox
@onready var player_regen : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Health_Regeneration/SpinBox_Health_Regeneration as SpinBox
@onready var player_armor : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Base_Armor/SpinBox_Base_Armor as SpinBox
@onready var player_move_speed : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Base_Move_Speed/SpinBox_Base_Move_Speed as SpinBox
@onready var player_sprint_speed : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Sprint_Move_Speed/SpinBox_Sprint_Move_Speed as SpinBox
@onready var player_acceleration : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Move_Speed_Acceleration/SpinBox_Move_Speed_Acceleration as SpinBox
@onready var player_jump_force : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Jump_Force/SpinBox_Jump_Force as SpinBox
@onready var player_i_frame_duration : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_I_Frame_Duration/SpinBox_I_Frame_Duration as SpinBox
@onready var player_consumable_switch_time : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Consumable_Switch_Time/SpinBox_Consumable_Switch_Time as SpinBox

@onready var player_air_control_scalar : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Air_Control_Scalar/SpinBox_Air_Control_Scalar as SpinBox
@onready var player_horizontal_mouse_sensitivity : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Horizontal_Mouse_Sensitivity/SpinBox_Horizontal_Mouse_Sensitivity as SpinBox
@onready var player_vertical_mouse_sensitivity : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Vertical_Mouse_Sensitivity/SpinBox_Vertical_Mouse_Sensitivity as SpinBox
@onready var player_max_vertical_aim : SpinBox = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Vertical_Mouse_Sensitivity/SpinBox_Vertical_Mouse_Sensitivity as SpinBox
@onready var player_gravity_hint : Label = $TabContainer/Player/ItemList_Player/ScrollContainer/VBoxContainer/HBoxContainer_Gravity_Hint/Label_Gravity_Hin_Details as Label


#endregion


#region InitializeOpponent





@onready var opponent_instance_template_path
@onready var opponent_save_button : Button = $TabContainer/Opponents/OpponentDetailsList/Button_Save_Opponent as Button

@onready var opponents_tabBar : TabBar = $TabContainer/Opponents as TabBar
@onready var opponent_item_list: ItemList = $TabContainer/Opponents/OpponentsList as ItemList
@onready var opponent_instance_template: HBoxContainer 
@onready var opponent_list_container: VBoxContainer = $TabContainer/Opponents/OpponentsList/ScrollContainer/VBoxContainer as VBoxContainer

@onready var opponent_name : TextEdit = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Name/TextEdit_Name as TextEdit
@onready var opponent_select_item : OptionButton = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_SelectItem/OptionButton_Mesh as OptionButton
@onready var opponent_move_speed : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Move_Speed/SpinBox_Move_Speed as SpinBox
@onready var opponent_acceleration : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Acceleration/SpinBox_Acceleration as SpinBox
@onready var opponent_jump_force : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Jump_Force/SpinBox_Jump_Force as SpinBox
@onready var opponent_gravity : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Gravity/SpinBox_Gravity as SpinBox
@onready var opponent_flight_height : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Flight_Height/SpinBox_Flight_Height as SpinBox
@onready var opponent_base_health : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Base_Health/SpinBox_Base_Health as SpinBox
@onready var opponent_health_regeneration : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Health_Regeneration/SpinBox_Health_Regeneration as SpinBox
@onready var opponent_base_armor : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Base_Armor/SpinBox_Base_Armor as SpinBox
@onready var opponent_attack_type : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Attack_Type/SpinBox_Attack_Type as SpinBox
@onready var opponent_attack_range_x : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Attack_Type/SpinBox_Attack_Type as SpinBox
@onready var opponent_attack_range_y : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Attack_Range/SpinBox_Attack_Range_Y as SpinBox
@onready var opponent_weapon_used : OptionButton = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Weapon_Used/OptionButton_Weapon_Used as OptionButton
@onready var opponent_first_charge_time : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_First_Charge_Time/SpinBox_First_Charge_Time as SpinBox
@onready var opponent_final_charge_time :  SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Final_Charge_Time/SpinBox_Final_Charge_Time as SpinBox
@onready var opponent_attack_recovery_time : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Attack_Recovery_Time/SpinBox_Attack_Recovery_Time as SpinBox
@onready var opponent_interrupt_recovery_time : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Interrupt_Revorery_Time/SpinBox_Interrupt_Revorery_Time as SpinBox
@onready var opponent_aggro_range : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Aggro_Range/SpinBox_Aggro_Range as SpinBox
@onready var opponent_loss_distance_from_idle : SpinBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Loss_Distance_From_Idle/SpinBox_Loss_Distance_From_Idle as SpinBox
@onready var opponent_can_be_interrupted : CheckBox = $TabContainer/Opponents/OpponentDetailsList/ScrollContainer/VBoxContainer/HBoxContainer_Can_Be_Interrupted/CheckBox_Can_Be_Interrupted as CheckBox

#endregion
func _ready():
	_check_weapon_instance_template_exist()
	_populate_weapon_files()
	_populate_opponent_meshes()
	opponent_item_list.connect("item_selected", Callable(self, "_on_item_selected"))
	_load_player_motor("res://Assets/Resources/Player/RE_PlayerConfig.tres")
	_list_opponents_files_in_directory("res://Assets/Resources/Opponents/")
	_init_ui(tab_container.current_tab)

func _generate_guid() -> int:
	return randi()

func _init_ui(current_tab: int) -> void:
	_on_tab_changed(current_tab)

func _on_tab_changed(tab_index: int) -> void:
	var current_tab_title = tab_container.get_tab_title(tab_index).to_lower()
	print("current tab title : " + current_tab_title)
	match current_tab_title:
		"player":
			player_tabBar.visible = true
			opponents_tabBar.visible = false
		"opponents":
			opponents_tabBar.visible = true
			player_tabBar.visible = false

func _create_player_file(file_path : String):
		var player_config = PlayerConfig.new()
		var error = ResourceSaver.save(player_config, file_path)
		if error == OK:
			print("Motor config saved successfully.")

func _on_button_save_pressed():
	var dir = DirAccess.open("res://Assets/Resources/Player/")
	var file_path : String = "res://Assets/Resources/Player/RE_PlayerConfig.tres"
	var player_config
	if dir.file_exists(file_path):
		player_config = ResourceLoader.load(file_path) as PlayerConfig
		if player_config:
			print("Fichier trouvé. Mise à jour des données...")
			_update_player_config(player_config)
		else:
			print("Erreur lors du chargement de la ressource.")
		var error = ResourceSaver.save(player_config, file_path)
		if error == OK:
			print("Motor config saved successfully.")
	else:
		print("Fichier non trouvé. Création d'une nouvelle instance...")
		_create_player_file(file_path)

func _update_player_config(player_config : PlayerConfig):
	player_config.base_health = player_base_health.value 
	player_config.health_regeneration = player_regen.value 
	player_config.base_armor = player_armor.value 
	player_config.base_move_speed = player_move_speed.value 
	player_config.sprint_move_speed = player_sprint_speed.value 
	player_config.move_speed_acceleration = player_acceleration.value 
	player_config.jump_force = player_jump_force.value 
	player_config.iframe_duration = player_i_frame_duration.value 
	player_config.consumable_switch_time = player_consumable_switch_time.value 
	player_config.air_control_scalar = player_air_control_scalar.value
	player_config.horizontal_mouse_sensitivity = player_horizontal_mouse_sensitivity.value
	player_config.vertical_mouse_sensitivity = player_vertical_mouse_sensitivity.value
	player_config.max_vertical_aim = player_max_vertical_aim.value

func _update_ui_player_config(player_config : PlayerConfig):
	player_base_health.value = player_config.base_health
	player_regen.value = player_config.health_regeneration
	player_armor.value = player_config.base_armor
	player_move_speed.value = player_config.base_move_speed
	player_sprint_speed.value = player_config.sprint_move_speed
	player_acceleration.value = player_config.move_speed_acceleration
	player_jump_force.value = player_config.jump_force
	player_i_frame_duration.value = player_config.iframe_duration
	player_consumable_switch_time.value = player_config.consumable_switch_time
	player_air_control_scalar.value = player_config.air_control_scalar
	player_horizontal_mouse_sensitivity.value = player_config.horizontal_mouse_sensitivity
	player_vertical_mouse_sensitivity.value =  player_horizontal_mouse_sensitivity.value
	player_max_vertical_aim.value = player_config.max_vertical_aim

func _load_player_motor(file_path : String) -> PlayerConfig:
	var dir = DirAccess.open("res://Assets/Resources/Player/")
	var player_config
	if dir.file_exists(file_path):
		player_config = ResourceLoader.load(file_path) as PlayerConfig
		if player_config:
			print("Fichier trouvé. Mise à jour des données...")
			_update_ui_player_config(player_config)
		else:
			print("Erreur lors du chargement de la ressource. Création d'une nouvelle instance...")
			_create_player_file(file_path)
			_update_ui_player_config(player_config)
		var error = ResourceSaver.save(player_config, file_path)
		if error == OK:
			print("Motor config saved successfully.")
		return player_config
	else:
		_create_player_file(file_path)  
		player_config = ResourceLoader.load(file_path) as PlayerConfig
		return player_config

	
#region opponent

func _populate_opponent_meshes():
	opponent_select_item.clear()
	var meshes = get_all_opponent_in_project()
	opponent_select_item.add_item("NONE")
	for mesh_path in meshes:
		opponent_select_item.add_item(mesh_path)

func _populate_weapon_files() -> int:
	opponent_weapon_used.clear()
	var weapon_files = get_weapon_files("res://Assets/Resources/Items/Weapons/")
	opponent_weapon_used.add_item("NONE")
	for file_path in weapon_files:
		opponent_weapon_used.add_item(file_path)
	return opponent_weapon_used.get_item_count()


func get_weapon_files(directory_path: String) -> Array:
	var file_paths = []
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				file_paths.append(directory_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path: ", directory_path)
	return file_paths

func _clear_opponent_list():
	for child in opponent_list_container.get_children():
		child.queue_free()

func _list_opponents_files_in_directory(directory_path: String):
	_clear_opponent_list()
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				_load_and_display_opponent_config(directory_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path: ", directory_path)

func _initialize_opponent_item_instance(opponent_config: OpponentConfig, file_path: String):
	var opponent_item_instance = opponent_instance_template.duplicate()
	if not opponent_item_instance:
		print("Failed to load weapon instance template from: ", opponent_instance_template_path)
		return
	opponent_item_instance.visible = true
	opponent_item_instance.get_node("B_ShowDetailsOpponent/L_NameOpponent").text = opponent_config.name
	opponent_item_instance.get_node("B_ShowDetailsOpponent").connect("pressed", _on_b_show_details_opponent_pressed.bind(opponent_config))
	var delete_button = opponent_item_instance.get_node("B_DeleteOpponent")
	if delete_button:
		delete_button.connect("pressed", _on_b_delete_opponent_pressed.bind(opponent_config, opponent_item_instance, file_path))
	opponent_list_container.add_child(opponent_item_instance)

func _load_and_display_opponent_config(file_path: String):
	var opponent_config := ResourceLoader.load(file_path) as OpponentConfig
	print("file path " + file_path)
	if opponent_config:
		_initialize_opponent_item_instance(opponent_config, file_path)
		print("Loaded opponent config: ", opponent_config.name)
	else:
		print("Failed to load opponent config from: ", file_path)

func _on_button_add_opponent_pressed() -> void:
	var opponent_config = OpponentConfig.new()
	opponent_config.id = _generate_guid()
	opponent_config.name = "New Opponent"
	if opponent_config.is_class("Resource") and opponent_config.name != "":
		var save_path = "res://Assets/Resources/Opponents/"+ opponent_config.name + str(opponent_config.id) + ".tres"
		var error = ResourceSaver.save(opponent_config,save_path)
		if error != OK:
			print("Error saving the resource: ", error)
		else:
			print("Resource successfully saved to: ", save_path)
		
		_initialize_opponent_item_instance(opponent_config, save_path)
		_list_opponents_files_in_directory("res://Assets/Resources/Opponents/")
	else:
		print("Error: Opponent configuration is invalid or incomplete.")

func _check_weapon_instance_template_exist():
	if not opponent_instance_template:
		opponent_instance_template_path = preload("res://addons/tool_player/h_box_opponents_container.tscn")
		opponent_instance_template = opponent_instance_template_path.instantiate()
	if not opponent_instance_template:
		print("Critical error: Unable to load opponent instance template.")
		return

func get_all_opponent_in_project(directory_path="res://"):
	var mesh_paths = []
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				mesh_paths.append(directory_path + file_name)
			elif dir.current_is_dir():
				mesh_paths += get_all_opponent_in_project(directory_path + file_name + "/")
			file_name = dir.get_next()
		dir.list_dir_end()
	return mesh_paths

func _on_b_delete_opponent_pressed(opponent_config: OpponentConfig, opponent_item_instance: Node, file_path: String):
	# Show a confirmation dialog before deleting
	var confirmation_dialog = ConfirmationDialog.new()
	confirmation_dialog.dialog_text = "Are you sure you want to delete this opponent: " + opponent_config.name + "?"
	confirmation_dialog.connect("confirmed", _confirm_delete_opponent.bind(opponent_config, opponent_item_instance, file_path))
	add_child(confirmation_dialog)
	confirmation_dialog.popup_centered()

func _confirm_delete_opponent(opponent_config: OpponentConfig, opponent_item_instance: Node, file_path: String):
	# Delete UI instance
	opponent_item_instance.queue_free()
	# Delete File System Configuration File
	var dir = DirAccess.open("res://Assets/Resources/Opponents/")
	if dir.remove(file_path) == OK:
		print("Opponent configuration file deleted successfully: ", file_path)
		EditorInterface.get_resource_filesystem().scan()
	else:
		print("Failed to delete opponent configuration file: ", file_path)

func _on_b_show_details_opponent_pressed(opponent_config: OpponentConfig):
	if (opponent_save_button.is_connected("pressed", _on_save_opponent_config_button_pressed.bind(opponent_config))):
		opponent_save_button.disconnect("pressed", _on_save_opponent_config_button_pressed.bind(opponent_config))
	opponent_save_button.connect("pressed", _on_save_opponent_config_button_pressed.bind(opponent_config))
	
	opponent_name.text = opponent_config.name
	if opponent_config.opponent_mesh != null:
		var opponent_mesh_path = opponent_config.opponent_mesh.resource_path
		for i in range(opponent_select_item.get_item_count()):
			if opponent_select_item.get_item_text(i) == opponent_mesh_path:
				opponent_select_item.select(i)
				break
	else:
		opponent_select_item.select(0)
	opponent_move_speed.value = opponent_config.move_speed
	opponent_acceleration.value = opponent_config.acceleration
	opponent_jump_force.value = opponent_config.jump_force
	opponent_gravity.value = opponent_config.gravity
	opponent_flight_height.value = opponent_config.flight_height
	opponent_base_health.value = opponent_config.base_health
	opponent_health_regeneration.value = opponent_config.health_regeneration
	opponent_base_armor.value = opponent_config.base_armor
	opponent_attack_type.value = opponent_config.attack_type
	opponent_attack_range_x.value = opponent_config.attack_range.x
	opponent_attack_range_y.value = opponent_config.attack_range.y
	if !opponent_config.weapon_used.resource_path.is_empty():
		var weapon_used_path = opponent_config.weapon_used.resource_path
		var count = _populate_weapon_files()
		for i in range(count):
			if opponent_weapon_used.get_item_text(i) == weapon_used_path:
				opponent_weapon_used.select(i)
				break
	else:
		opponent_weapon_used.select(0)
	opponent_first_charge_time.value = opponent_config.first_charge_time
	opponent_final_charge_time.value = opponent_config.final_charge_time
	opponent_attack_recovery_time.value = opponent_config.attack_recovery_time
	opponent_interrupt_recovery_time.value = opponent_config.interrupt_revorery_time
	opponent_aggro_range.value = opponent_config.aggro_range
	opponent_loss_distance_from_idle.value = opponent_config.loss_distance_from_idle
	opponent_can_be_interrupted.button_pressed = opponent_config.can_be_interrupted

func _on_save_opponent_config_button_pressed(opponent_config: OpponentConfig):
	_update_opponent_config(opponent_config)
	var file_path = "res://Assets/Resources/Opponents/" + opponent_config.name + str(opponent_config.id) + ".tres"
	var error_save = ResourceSaver.save(opponent_config, file_path)
	if error_save != OK:
		print("Error saving the resource: ", error_save)
	else:
		print("Resource successfully saved to: ", file_path)

func _update_opponent_config(opponent_config: OpponentConfig):
	opponent_config.name = opponent_name.text
	
	var opponent_mesh_path = opponent_select_item.get_item_text(opponent_select_item.get_selected_id())
	if opponent_mesh_path != "NONE":
		opponent_config.opponent_mesh = load(opponent_mesh_path) as PackedScene
	else:
		opponent_config.opponent_mesh = null
	
	opponent_config.move_speed = opponent_move_speed.value
	opponent_config.acceleration = opponent_acceleration.value
	opponent_config.jump_force = opponent_jump_force.value
	opponent_config.gravity = opponent_gravity.value
	opponent_config.flight_height = opponent_flight_height.value
	opponent_config.base_health = opponent_base_health.value
	opponent_config.health_regeneration = opponent_health_regeneration.value
	opponent_config.base_armor = opponent_base_armor.value
	opponent_config.attack_type = opponent_attack_type.value
	opponent_config.attack_range = Vector2(opponent_attack_range_x.value, opponent_attack_range_y.value)
	
	
	var weapon_used_path = opponent_weapon_used.get_item_text(opponent_weapon_used.get_selected_id())
	if weapon_used_path != "NONE":
		opponent_config.weapon_used = ResourceLoader.load(weapon_used_path) as WeaponConfig
	else:
		opponent_config.weapon_used = null
	
	
	
	opponent_config.first_charge_time = opponent_first_charge_time.value
	opponent_config.final_charge_time = opponent_final_charge_time.value
	opponent_config.attack_recovery_time = opponent_attack_recovery_time.value
	opponent_config.interrupt_revorery_time = opponent_interrupt_recovery_time.value
	opponent_config.aggro_range = opponent_aggro_range.value
	opponent_config.loss_distance_from_idle = opponent_loss_distance_from_idle.value
	opponent_config.can_be_interrupted = opponent_can_be_interrupted.button_pressed
	_on_b_show_details_opponent_pressed(opponent_config)

#endregion

