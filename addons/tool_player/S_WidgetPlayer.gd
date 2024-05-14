@tool
extends Control

@onready var tab_container : TabContainer = $TabContainer as TabContainer


#region InitializeWeapon
@onready var plauyer_instance_template_path

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


#@onready var player_stamina : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_Stamina/SpinBox_Stamina as SpinBox
#@onready var player_fall_speed : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_FallSpeed/SpinBox_FallSpeed as SpinBox

#endregion

@onready var opponents_tabBar : TabBar = $TabContainer/Opponents as TabBar


func _ready():
	_init_ui(tab_container.current_tab)
	_load_player_motor("res://Assets/Resources/Player/RE_PlayerConfig.tres")

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
	player_config.i_frame_duration = player_i_frame_duration.value 
	player_config.consumable_switch_time = player_consumable_switch_time.value 
	player_config.air_control_scalar = player_air_control_scalar.value
	player_config.horizontal_mouse_sensitivity = player_horizontal_mouse_sensitivity.value
	player_config.vertical_mouse_sensitivity = player_vertical_mouse_sensitivity.value
	player_config.max_vertical_aim = player_max_vertical_aim.value
	#player_config.fall_speed = player_fall_speed.value 
	#= player_config. = player_stamina.value
	
func _update_ui_player_config(player_config : PlayerConfig):
	player_base_health.value = player_config.base_health
	player_regen.value = player_config.health_regeneration
	player_armor.value = player_config.base_armor
	player_move_speed.value = player_config.base_move_speed
	player_sprint_speed.value = player_config.sprint_move_speed
	player_acceleration.value = player_config.move_speed_acceleration
	player_jump_force.value = player_config.jump_force
	player_i_frame_duration.value = player_config.i_frame_duration
	player_consumable_switch_time.value = player_config.consumable_switch_time
	player_air_control_scalar.value = player_config.air_control_scalar
	player_horizontal_mouse_sensitivity.value = player_config.horizontal_mouse_sensitivity
	player_vertical_mouse_sensitivity.value =  player_horizontal_mouse_sensitivity.value
	player_max_vertical_aim.value = player_config.max_vertical_aim
	#player_fall_speed.value = player_config.fall_speed
	#player_stamina.value = player_config.



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

