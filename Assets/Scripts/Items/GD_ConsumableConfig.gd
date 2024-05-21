extends ItemConfig
class_name ConsumableConfig

@export_subgroup("Heal or Damage")
@export var use_heal_damage : bool = false
@export var heal_damage : float = 0
@export_subgroup("Armor")
@export var use_armor : bool = false
@export var armor : float = 0
@export_subgroup("Stun Duration")
@export var use_stun : bool = false
@export var stun_duration : float = 0
@export_subgroup("Speed Boost")
@export var use_speed_boost : bool = false
@export var speed_boost : float = 0
@export_subgroup("Invisibility Duration")
@export var use_invisibility : bool = false
@export var invisibility_duration : float = 0
@export_subgroup("Jump Force Boost")
@export var use_jump_force_boost : bool = false
@export var jump_force_boost : float = 0
@export_subgroup("Damage Boost")
@export var use_damage_boost : bool = false
@export var damage_boost : float = 0

@export_group("Settings")
@export var speed : float = 0
@export var lifetime : float = 0
