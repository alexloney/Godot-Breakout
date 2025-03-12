extends Control

func _process(delta: float) -> void:
	$HighScoreLabel.text = "High Score: " + str(GameManager.get_high_score())

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
