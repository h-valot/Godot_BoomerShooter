class_name Enums

## NEUTRAL can be damaged by every source of damage including itself. 
## PLAYER can be damaged by NEUTRAL and OPPONENT but not by itself.  
## OPPONENT can be damaged by PLAYER and NEUTRAL but not by itself.
enum HealthType {
	NEUTRAL,
	PLAYER,
	OPPONENT
}

enum QuestConditionType {
	NONE,
	PLAYER_DIED,
	TIME_ELAPSED,
	INTERACTABLE_INTERACTED,
	ENTITY_KILLED,
	DIALOGUE_ENDED,
	GAME_BEGAN
}