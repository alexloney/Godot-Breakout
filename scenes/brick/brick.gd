extends Node2D

var color: String = "ffffff"

# When a brick is destroyed, trigger the particles for the destroy event and
# begin playing the destroy animation
func destroy_brick() -> void:
	$Particles.emitting = true
	$Particles.position.x = position.x
	$Particles.position.y = position.y
	$BrickBody/CollisionShape2D.set_deferred("disabled", true)
	$BrickDetector/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("destroy")

# Set the color of this block, including a matching particle color
func set_color(new_color) -> void:
	color = new_color
	$BrickBody/Line2D.default_color = color
	$Particles.color = color

# When the particles finish emitting, destroy this object
func _on_particles_finished() -> void:
	queue_free()
