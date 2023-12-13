## A RigidBody2D that will wrap around the viewport when travelling past the bounds
class_name WrappingRigidBody2D extends RigidBody2D

## extra area around the viewport the object can travel to hide a jarring object teleportation
@export var margin: int = 0

var boundary : Rect2

# expands the boundary to include the specified margins
func _ready():	
	var view = get_viewport_rect()
	boundary = view \
		.expand(Vector2(0-margin, 0-margin)) \
		.expand(Vector2(view.size.x+margin, view.size.y+margin))


# wraps the object across the window
func _integrate_forces(state):
	if not boundary.has_point(global_position):
		var x = wrapf(global_position.x, boundary.position.x, boundary.position.x+boundary.size.x)
		var y = wrapf(global_position.y, boundary.position.y, boundary.position.y+boundary.size.y)
		state.transform = Transform2D(rotation, Vector2(x,y))
