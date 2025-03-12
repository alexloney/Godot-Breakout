extends StaticBody2D

var paddle_width: int = 162
var default_paddle_width: int = 162
var reduced_paddle_width: int = 121

var paddle_scale: float = 1.0
var default_paddle_scale: float = 1.0
var reduced_paddle_scale: float = 0.75

# Using the viewport and the width of the paddle, ensure that the paddle is within the
# bounds of the screen. This also accounts for both small/large paddles
func apply_bounds() -> void:
	if paddle_scale == default_paddle_scale:
		position.x = clamp(position.x, 0 + paddle_width / 2, get_viewport().size.x - paddle_width / 2)
	else:
		position.x = clamp(position.x, 0 + reduced_paddle_width / 2, get_viewport().size.x - reduced_paddle_width / 2)

# Reduce the size of the paddle by switching from the large to the small paddle
func reduce_paddle_size() -> void:
	scale.x = reduced_paddle_scale
	paddle_scale = reduced_paddle_scale
	
# keep the paddle aligned with the mouse movements, so every time the mouse moves,
# move the paddle to the same spot
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position.x = event.position.x
		apply_bounds()
