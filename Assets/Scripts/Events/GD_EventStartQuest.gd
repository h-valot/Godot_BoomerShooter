extends Event
class_name EventStartQuest

@export_category("Event")
@export var quest: Quest = null


func execute():
	
	super.execute()
	
	quest.start()