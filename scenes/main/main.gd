extends Node

@export var brick : PackedScene
@export var ball : PackedScene

var lives: int = 3
var score: int = 0
var game_is_over: bool = false
var game_started: bool = false

var brick_columns: int = 10
var brick_rows: int = 8
var brick_horizontal_spacing: int = 15
var brick_vertical_spacing: int = 20
var brick_width: int = 76
var brick_height: int = 10

var block_colors_by_row: Array[String] = [
	"ffc6ff", # Red
	"bdb2ff", # Orange
	"a0c4ff", # Yellow
	"9bf6ff", # Green
	"caffbf", # Blue
	"fdffb6", # Darker Blue
	"ffd6a5", # Indigo
	"ffadad"] # Violet

func reset_bricks() -> void:
	# Calculate the starting X position of the bricks based on the number of columns of bricks we
	# have and the spacing between the bricks, this will center the bricks in the viewport based
	# on the viewport size
	var brick_start_x = (get_viewport().size.x - ((brick_columns - 1) * brick_width + (brick_columns - 1) * brick_horizontal_spacing)) / 2
	
	# Setting a starting brick Y position of 70, just because it's "good enough" and doesn't really
	# need any dynamic calculation.
	var brick_start_y = 70
	
	# Loop through the brick rows/columns and add the bricks to the scene. Once added, connect the
	# brick detector to the callback as well for detecting ball hits.
	for column in range(0, brick_columns):
		for row in range(0, brick_rows):
			var new_brick = brick.instantiate()
			new_brick.position.x = brick_start_x + (brick_horizontal_spacing + brick_width) * column
			new_brick.position.y = brick_start_y + (brick_height + brick_vertical_spacing) * row
			new_brick.set_color(block_colors_by_row[row])
			
			var new_brick_detector = new_brick.get_node("BrickDetector")
			new_brick_detector.connect("body_exited", _on_brick_detector_body_exited.bind(new_brick))
			
			add_child(new_brick)

# Reset the ball position to the center of the paddle
func reset_ball() -> void:
	$Ball.position = Vector2($Paddle.position.x, $Paddle.position.y - 15)

# Reset the paddle position to the center of the screen
func reset_paddle() -> void:
	$Paddle.position.x = get_viewport().size.x / 2

# Reset both the paddle and ball
func reset_paddle_and_ball() -> void:
	reset_paddle()
	reset_ball()

# Reduce life by one, call game over if lives are fully gone
func life_lost() -> void:
	game_started = false
	lives -= 1
	
	reset_ball()
	
	if lives <= 2:
		$Heart3.hide()
	if lives <= 1:
		$Heart2.hide()
	if lives <= 0:
		$Heart1.hide()
		game_over()

# Increase the score by one then display it
func increase_score() -> void:
	score += 1
	GameManager.set_high_score(score)
	display_score()

# Display the current score to the screen
func display_score() -> void:
	$ScoreScreen/ScoreLabel.text = str(score)

# Game has ended, show the game over screen
func game_over() -> void:
	game_is_over = true
	$GameOverScreen.show()

# Start the game
func start_game() -> void:
	game_started = true
	game_is_over = false
	$Ball.begin_movement()


func _ready() -> void:
	reset_bricks()
	display_score()

func _process(delta: float) -> void:
	# If the game is not started, stick the ball to the paddle
	if not game_started:
		$Ball.position = Vector2($Paddle.position.x, $Paddle.position.y - 15)

func _input(event: InputEvent) -> void:
	if game_is_over:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not game_started:
			$Ball.reset_speed()
			start_game()

# When the ceiling is hit, reduce the paddle size. This size reduction is handled
# by the paddle itself, so if we'd like to implement multiple size reductions,
# that may be done within the paddle
func _on_ceiling_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		$Paddle.reduce_paddle_size()

# When the ball hits the floor, lose a life.
func _on_floor_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		life_lost()

# When the ball hits a brick, tell the brick it has been hit
func _on_brick_detector_body_exited(body: Node2D, brick: Node2D) -> void:
	if body.is_in_group("Ball"):
		$HitSound.play()
		increase_score()
		brick.destroy_brick()
		body.increase_speed()
