extends WrappingRigidBody2D

## emitted when the destroy method of this object is called
## returns the position "p" of the destoyed rock
signal rock_destroyed(pos: Vector2, rock_type: RockType, points: int)

## the point value of the destroyed rocks
@export var points: int = 0

## the rock type
enum RockType { BIG_ROCK, SMALL_ROCK }
@export var rock_type: RockType

## the explosion animation to play when the rock is destroyed
@export var explosion_scene: PackedScene


func _ready():
	super._ready()
	rotation_degrees = randi() % 360
	linear_velocity = linear_velocity.rotated(rotation)


## destroys the rock, plays the explosion animation, and frees this object from memory
func destroy():
	rock_destroyed.emit(global_position, rock_type, points)
	hide_rock()
	show_explosion()


func hide_rock():
	$Rock.set_deferred("visible", false)
	$CollisionPolygon2D.set_deferred("disabled", true)


func show_explosion():
	var explosion = explosion_scene.instantiate()
	if not explosion.is_connected("finished", _on_explosion_finished):
		explosion.connect("finished", _on_explosion_finished)
	add_child(explosion)


func _on_explosion_finished():
	queue_free()
