extends Event
class_name EventKillPlayer

@export_group("Forbidden")
@export var rse_kill_player: RuntimeScriptableEventT0 = null


func execute():
	
	super.execute()

	# kills the player
	rse_kill_player.trigger()