extends Node3D

class_name UseConsumable

@export var local_player: Player
@export var head: Node3D

@export var throw_forward_offset: float = 2.5
@export var throw_height_offset: float = 1.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func use_consumable(consumable: ConsumableConfig):
	UseConsumable.apply_consumable_effect(local_player, consumable)

static func apply_consumable_effect(_target: Node, consumable: ConsumableConfig, can_hit_player: bool = true) -> bool:
	var player = _target as Player
	var opponent = _target as Opponent

	if can_hit_player && player == null:
		player = _target.get_parent() as Player
	elif opponent == null:
		if _target.get_parent() != null:
			opponent = _target.get_parent().get_parent() as Opponent

	if can_hit_player && player != null:
		if consumable.use_heal_damage:
			player._health_component.update_current_health(consumable.heal_damage)

		if consumable.use_armor:
			player._health_component.add_armor(consumable.armor)

		if consumable.use_stun:
			pass

		if consumable.use_invisibility:
			player.player_config.is_invisible = true
			player.get_tree().create_timer(consumable.duration).timeout.connect(
				func():  player.player_config.is_invisible = false
			)

		if consumable.use_jump_force_boost:
			var base_jump_force: float = player.player_config.jump_force;
			player.player_config.jump_force = player.player_config.jump_force + consumable.jump_force_boost;
			player.get_tree().create_timer(consumable.duration).timeout.connect(
				func():  player.player_config.jump_force = base_jump_force
			)

		if consumable.use_speed_boost:
			var base_speed: float = player.player_config.base_move_speed;
			player.player_config.base_move_speed = player.player_config.base_move_speed + consumable.speed_boost;
			player.get_tree().create_timer(consumable.duration).timeout.connect(
				func():  player.player_config.base_move_speed = base_speed
			)
		return true
	elif (opponent):
		if consumable.use_heal_damage:
			opponent._health_component.update_current_health(consumable.heal_damage)

		if consumable.use_armor:
			opponent._health_component.add_armor(consumable.armor)

		if consumable.use_stun:
			opponent._move_funtion_enabled = false
			opponent.get_tree().create_timer(consumable.duration).timeout.connect(
				func():  opponent._move_funtion_enabled = true
			)

		if consumable.use_invisibility:
			pass

		if consumable.use_jump_force_boost:
			var base_jump_force: float = opponent.opponent_config.jump_force;
			opponent.opponent_config.jump_force = opponent.opponent_config.jump_force + consumable.jump_force_boost;
			opponent.get_tree().create_timer(consumable.duration).timeout.connect(
				func():  opponent.opponent_config.jump_force = base_jump_force
			)

		if consumable.use_speed_boost:
			var base_speed: float = opponent.opponent_config.base_move_speed;
			opponent.opponent_config.base_move_speed = opponent.opponent_config.base_move_speed + consumable.speed_boost;
			opponent.get_tree().create_timer(consumable.duration).timeout.connect(
				func():  opponent.opponent_config.base_move_speed = base_speed
			)
		return true
	return false

func throw_consumable(consumable: ConsumableConfig):
	var prefab = consumable.item_mesh.instantiate() as Node3D
	assert(prefab != null, "The item mesh must be an item 3D")

	var consumable_object: ConsumableObject = null
	for child in prefab.get_child(0).get_children():
		if child as ConsumableObject != null:
			consumable_object = child as ConsumableObject

	assert(consumable_object != null, "ConsumableObject not found in prefab in Rigidbody3D child node.")
	consumable_object.consumable = consumable
	
	get_tree().current_scene.add_child(prefab)
	prefab.position = head.global_position + ((Vector3.UP * throw_height_offset) * head.global_basis ) + ((Vector3.FORWARD * throw_forward_offset) * head.global_basis)
	
	var rigidbody = InventoryUtils.get_child_of_type(prefab, typeof(RigidBody3D))
	assert(rigidbody != null, "Missing rigidbody in consumable prefab.")
	
	var forward_dir: Vector3 = (head.global_basis * Vector3.FORWARD).normalized()

	rigidbody.can_sleep = false
	rigidbody.apply_impulse(forward_dir * consumable.speed)

	InventoryUtils.call_latent_s(self, prefab, func(): prefab.queue_free(), consumable.lifetime)
