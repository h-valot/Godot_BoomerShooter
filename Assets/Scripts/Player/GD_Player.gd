extends Node
class_name Player

@export_category("References")
@export var player_config : PlayerConfig
@export var player_motor : PlayerMotor
@export var player_fire : PlayerFire
@export_group("Firing")
@export var bullet_prefab : PackedScene
@export var weapon_config : WeaponConfig

func _ready():
	player_motor.initialize(player_config)
	player_fire.initialize(bullet_prefab, weapon_config)
