extends Node

# Keep track of the high score
var high_score: int = 0

# Retreive the high score
func get_high_score() -> int:
	return high_score

# Store a new high score, only if it's larger than the current high score
func set_high_score(new_score) -> void:
	if new_score > high_score:
		high_score = new_score
