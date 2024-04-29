extends ItemConfig
class_name WeaponConfig

@export_group("Weapon")
@export var switch_speed : float = 0.5
@export var icon_2D: Texture
@export_subgroup("Mag")
@export var mag_size : float = 30
@export var starting_mag_amount : float = 10
@export var reload_time : float = 0
@export_subgroup("Shot")
@export var recoil_strength : float = 10
@export var bullet_amount_per_shot : float = 10
@export var spread : float = 10
@export var fire_rate : float = 0.25

@export_group("Bullet")
@export var bullet_mesh : PackedScene
@export var hit_scan : bool = true
@export var interrupts_npc_attack : bool = false
@export var bullet_damage : float = 10
@export var bullet_start_speed : float = 30
@export var bullet_lifetime : float = 3
@export var bullet_gravity_scale : float = 0
@export var impact_size : float = 1
