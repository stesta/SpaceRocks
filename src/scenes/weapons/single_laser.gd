extends Area2D

signal laser_hit_object(body)

@export var speed: Vector2 = Vector2(750,0)

var margin: int = 20
var boundary: Rect2

func _ready():
	var view = get_viewport_rect()
	boundary = view \
		.expand(Vector2(0-margin, 0-margin)) \
		.expand(Vector2(view.size.x+margin, view.size.y+margin))


func _process(delta):
	position += speed.rotated(rotation) * delta
	if not boundary.has_point(global_position):
		queue_free()


func _on_body_entered(body):
	laser_hit_object.emit(body)
	queue_free()
