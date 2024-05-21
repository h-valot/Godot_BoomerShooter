extends ItemConfig
class_name WeaponConfig

@export_group("Weapon")
@export var switch_speed : float = 0.5

@export_subgroup("Mag")
@export var mag_size : int = 30
@export var starting_mag_amount : int = 10
@export var reload_time : float = 1
var stored_bullet_amount: int = 0
var current_bullet_amount: int = 0

@export_subgroup("Shot")
@export var recoil_scalar : float = 10
@export var recoil_curve : Curve
@export var camera_shake_strength : float = 3
@export var camera_shake_fade : float = 5
@export var bullet_amount_per_shot : int = 10
@export var spread : float = 10
@export var raycast_length : float = 100
@export var fire_rate : float = 0.25


@export_group("Bullet")
@export var bullet_mesh : PackedScene
@export var hit_scan : bool = true
@export var interrupts_npc_attack : bool = false
@export var bullet_damage : float = 10
@export var bullet_start_speed : float = 30
@export var bullet_lifetime : float = 3
@export var bullet_gravity_scale : float = 0

@export_subgroup("Zone")
@export var create_zone_on_impact : bool = true
@export var zone_prefab : PackedScene
@export var zone_radius : float = 1
@export var zone_lifetime : float = 1
@export var zone_damage_per_tick : float = 1
@export var zone_tick_duration : float = 1


## Bullet amount is handle in the [WeaponConfig]
## This function must be called only when the weapon is picked-up
func initialize_mag():
	
	if (starting_mag_amount <= 0):
		return;
	
	stored_bullet_amount = mag_size * (starting_mag_amount - 1)
	current_bullet_amount = mag_size