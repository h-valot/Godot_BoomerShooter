extends Resource
class_name OpponentConfig

@export var name : String = ""
@export var opponent_mesh : PackedScene

@export_group("Movement")
@export var move_speed : float = 5
@export var acceleration : float = 1
@export var jump_force : float = 4.5
@export var fall_speed : float = 9.8
@export_subgroup("Flying")
## Offset the y position of the opponent. If set to 0, it stays on ground.
@export var flight_height : float = 0

@export_group("Health")
## Set the current health of the opponent to this base health on game launches.
@export var base_health : float = 50
## Increament current health by health regeneration every seconds.
@export var health_regeneration : float = 1
@export var base_armor : float = 0

@export_group("Attack")
## Can be melee, distance or special
@export_enum("MELEE", "DISTANCE", "SPECIAL") var attack_type : int = 1
## Minimum and maximum distance to cast an attack
@export var attack_range : Vector2 = Vector2(0, 1)
## Damage dealt to the touched hitbox when attacking
@export var attack_damage : float = 10
@export_subgroup("Projectile")
## Shot fired in one second.
@export var attack_rate : float = 1
## Angle of bullets spread in degree.
@export var spread : float = 0
## Number of projectile throw per shot
@export var projectile_per_attack : int = 1
## Speed of projectiles
@export var projectile_speed : float = 5
@export_subgroup("Charge")
@export var first_charge_time : float = 1
@export var final_charge_time : float = 1
@export var lock_time : float = 1
@export_subgroup("Zone")
@export var zone_size : float = 1
@export var zone_duration : float = 1
@export_subgroup("Recovery")
@export var attack_recovery_time : float = 1
@export var interrupt_revorery_time : float = 1

@export_group("Behaviour")
@export_enum("RANGE", "REACTION", "TRIGGER") var aggro_type : int = 1
## If the distance between the opponent and the character is below this threshold, the opponent aggro the character
@export var aggro_range : float = 1
## If the distance between the opponent and the character is above this threshold, the opponent loses the aggro
@export var aggro_loss_range : float = 3
@export var reaction_time : float = 1
## If the weapon used by the weapon interrupts and this opponent can be interrupt, the attack of the opponent will be interrupted 
@export var can_be_interrupted : bool = false

@export_group("Death")
## Event called on opponent death
@export var event_on_death : float = -1
