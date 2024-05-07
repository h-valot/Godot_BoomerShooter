@tool
extends Control

@onready var tab_container : TabContainer = $TabContainer as TabContainer


#region InitializeWeapon
@onready var weapon_instance_template_path

@onready var player_save_button : Button = $TabContainer/Player/Button_Save_Player as Button

@onready var player_tabBar : TabBar = $TabContainer/Player as TabBar

@onready var player_move_speed : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_MoveSpeed/SpinBox_MoveSpeed as SpinBox
@onready var player_sprint_speed : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_SprintSpeed/SpinBox_SprintSpeed as SpinBox
@onready var player_acceleration : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_Acceleration/SpinBox_Acceleration as SpinBox
@onready var player_jump_force : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_JumpForce/SpinBox_JumpForce as SpinBox
@onready var player_fall_speed : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_FallSpeed/SpinBox_FallSpeed as SpinBox
@onready var player_hp : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_HP/SpinBox_HP as SpinBox
@onready var player_regen : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_Regen/SpinBox_Regen as SpinBox
@onready var player_armor : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_Armor/SpinBox_Armor as SpinBox
@onready var player_stamina : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_Stamina/SpinBox_Stamina as SpinBox
@onready var player_i_frame_duration : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_IFrameDurantion/SpinBox_IFrameDurantion as SpinBox
@onready var player_consumable_switch_time : SpinBox = $TabContainer/Player/PlayerList/VScrollBar/VBoxContainer/HBoxContainer_ConsumableSwitchTime/SpinBox_ConsumableSwitchTime as SpinBox

#endregion

@onready var opponents_tabBar : TabBar = $TabContainer/Opponents as TabBar


func _ready():
	_init_ui(tab_container.current_tab)
	_load_player_motor("res://Assets/Resources/Characters/player_motor.tres")

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
		var player_motor = Motor.new()
		var error = ResourceSaver.save(player_motor, file_path)
		if error == OK:
			print("Motor config saved successfully.")
		
func _on_saved_player():
	var dir = DirAccess.open("res://Assets/Resources/Characters/")
	var file_path : String = "res://Assets/Resources/Characters/player_motor.tres"
	var player_motor
	if dir.file_exists(file_path):
		player_motor = ResourceLoader.load(file_path) as Motor
		if player_motor:
			print("Fichier trouvé. Mise à jour des données...")
			_update_motor_properties(player_motor)
		else:
			print("Erreur lors du chargement de la ressource.")
		var error = ResourceSaver.save(player_motor, file_path)
		if error == OK:
			print("Motor config saved successfully.")
	else:
		print("Fichier non trouvé. Création d'une nouvelle instance...")
		_create_player_file(file_path)
	dir.free()

func _update_motor_properties(player_motor : Motor):
	player_motor.base_movement_speed = player_move_speed.value 
	player_motor.sprint_movement_speed = player_sprint_speed.value 
	player_motor.movement_speed_acceleration = player_acceleration.value 
	player_motor.jump_force = player_jump_force.value 
	#player_motor.fall_speed = player_fall_speed.value 
	player_motor.max_health_points = player_hp.value 
	player_motor.health_regeneration = player_regen.value 
	player_motor.armor = player_armor.value 
	#= player_motor. = player_stamina.value
	player_motor.i_frame_duration = player_i_frame_duration.value 
	player_motor.consumable_switch_time = player_consumable_switch_time.value 
	
func _update_ui_motor_properties(player_motor : Motor):
	player_move_speed.value = player_motor.base_movement_speed
	player_sprint_speed.value = player_motor.sprint_movement_speed
	player_acceleration.value = player_motor.movement_speed_acceleration
	player_jump_force.value = player_motor.jump_force
	#player_fall_speed.value = player_motor.fall_speed
	player_hp.value = player_motor.max_health_points
	player_regen.value = player_motor.health_regeneration
	player_armor.value = player_motor.armor
	#player_stamina.value = player_motor.
	player_i_frame_duration.value = player_motor.i_frame_duration
	player_consumable_switch_time.value = player_motor.consumable_switch_time
	#IL EN MANQUE


func _load_player_motor(file_path : String) -> Motor:
	var dir = DirAccess.open("res://Assets/Resources/Characters/")
	var player_motor
	if dir.file_exists(file_path):
		player_motor = ResourceLoader.load(file_path) as Motor
		if player_motor:
			print("Fichier trouvé. Mise à jour des données...")
			_update_motor_properties(player_motor)
		else:
			print("Erreur lors du chargement de la ressource. Création d'une nouvelle instance...")
			_create_player_file(file_path)
			_update_ui_motor_properties(player_motor)
		var error = ResourceSaver.save(player_motor, file_path)
		if error == OK:
			print("Motor config saved successfully.")
		dir.free()
		return player_motor
	else:
		_create_player_file(file_path)  
		player_motor = ResourceLoader.load(file_path) as Motor
		return player_motor
