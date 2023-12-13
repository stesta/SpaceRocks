extends WrappingRigidBody2D

signal player_destroyed(position: Vector2)

## the amount of thrust the ship can generate
@export var thrust: Vector2 = Vector2(500,0)
## how quickly the ship can rotate
@export var rotation_speed: int = 2000
## the particle effect displayed when the ship explodes
@export var explosion_scene: PackedScene
## the scene for the bullet/laser used when the ship is firing
@export var weapon_scene: PackedScene

var alive: bool = true

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		fire_weapon()


func _integrate_forces(state):
	super._integrate_forces(state)
	
	if Input.is_action_pressed("up"):
		$Thruster.visible = true
		apply_force(thrust.rotated(rotation), Vector2.ZERO)
	else:
		$Thruster.visible = false
	
	var rotation_direction = Input.get_axis("left", "right")
	apply_torque(rotation_direction * rotation_speed)


func fire_weapon():
	if alive:
		var shot = weapon_scene.instantiate();
		shot.rotation = rotation
		shot.global_position = $BulletMarker.global_position
		$"../Projectiles".add_child(shot)


func destroy_ship():
	alive = false
	player_destroyed.emit(global_position)
	hide_ship()
	show_explosion()


func hide_ship():
	$Thruster.set_deferred("visible", false)
	$Ship.set_deferred("visible", false)
	$CollisionPolygon2D.set_deferred("disabled", true)


func show_explosion():
	var explosion = explosion_scene.instantiate()
	if not explosion.is_connected("finished", _on_explosion_finished):
		explosion.connect("finished", _on_explosion_finished)
	add_child(explosion)


func _on_explosion_finished():
	queue_free()
