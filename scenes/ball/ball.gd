extends RigidBody2D

@export var speed: float = 500
var velocity: Vector2 = Vector2(0, 0)
var speed_increment: float = 25
var default_speed: float = 500

# Begin movement in a random direction for the ball. The direction is normalized
# as we are using a "speed" variable to determine the speed.
func begin_movement() -> void:
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Add the speed increment to the ball, this allows it to become a little more
# difficult as time progresses
func increase_speed() -> void:
	speed += speed_increment

# Reset the speed back to the default speed settings
func reset_speed() -> void:
	speed = default_speed

# Detect physics collisions and bounce off of walls/objects
func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * speed * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
