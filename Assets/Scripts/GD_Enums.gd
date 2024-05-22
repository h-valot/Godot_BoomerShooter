class_name Enums

## NEUTRAL can be damaged by every source of damage including itself. 
## PLAYER can be damaged by NEUTRAL and OPPONENT but not by itself.  
## OPPONENT can be damaged by PLAYER and NEUTRAL but not by itself.
enum HealthType {
	NEUTRAL,
	PLAYER,
	OPPONENT
}

enum QuestCondition {
	NONE,
	PLAYER_DIED,
	TIME_ELAPSED,
	INTERACTED_IN_AREA,
	ENTITY_KILLED,
	DIALOGUE_ENDED,
	GAME_BEGAN
}