extends Resource
class_name OpponentConfig

@export var name : String = ""
@export var opponent_mesh : PackedScene

@export_group("Movement")
@export var move_speed : float = 5
@export var acceleration : float = 10
@export var jump_force : float = 4.5
@export var gravity : float = 9.8

@export_subgroup("Flying")
## Offset the y position of the opponent. If set to 0, it stays on ground.
## NOT IMPLEMENTED YET - We can not just offset the position of a node. 
## Even though, offsetted opponent moves on the same navigation mesh as the landed one. 
## So, if a land opponent avoid a wall, flying one will do so.
@export var flight_height : float = 0


@export_group("Health")
## Set the current health of the opponent to this base health on game launches.
@export var base_health : float = 50
## Increament 'current_health' by 'health_regeneration' every seconds.
@export var health_regeneration : float = 1
## Extra life that can not be regenerate
@export var base_armor : float = 0


@export_group("Attack")
## Can be melee, distance or special
@export_enum("MELEE", "RANGE", "SPECIAL") var attack_type : int = 1
## Minimum and maximum distance to cast an attack
@export var attack_range : Vector2 = Vector2(0, 1)
## Damage dealt to the touched hitbox when attacking
@export var attack_damage : float = 10

@export_subgroup("Projectile")
## Weapon used to shot projectiles
@export var weapon_used : WeaponConfig

@export_subgroup("Charge")
## Delay while the opponent continue moving towards the target before attacking
@export var first_charge_time : float = 1
## Delay while the opponent stops moving right before attacking
@export var final_charge_time : float = 1

@export_subgroup("Recovery")
## Delay while the opponent stops moving right after landing an attack
@export var attack_recovery_time : float = 1
## TODO - Delay while the opponent stops moving after being interrupted
@export var interrupt_revorery_time : float = 1


@export_group("Behaviour")
@export var custom_aggro_triggers : Array = []
## If the distance between the idle position of the opponent and the character is below this threshold, the opponent aggro the character
@export var aggro_range : float = 10
## If the distance between the idle position of the opponent and the character is above this threshold, the opponent loses the aggro
@export var loss_distance_from_idle : float = 100
## If the weapon used by the weapon interrupts and this opponent can be interrupt, the attack of the opponent will be interrupted 
@export var can_be_interrupted : bool = false


@export_group("Death")
## TODO - Event called on opponent death
@export var event_on_death : float = -1
