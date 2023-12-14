extends Node2D

@export var big_rock: PackedScene

@export var small_rock: PackedScene

@export var projectiles_node: Node

@export var rocks_node: Node

@export var player: RigidBody2D

@export var score: Label

@export var restart_timer: Timer


# Local State
var _score: int = 0


func _process(_delta):
	# connect collisions
	for projectile in projectiles_node.get_children():
		if !projectile.is_connected("laser_hit_object", _on_laser_hit_object):
			projectile.connect("laser_hit_object", _on_laser_hit_object)
			
	for rock in rocks_node.get_children():
		if !rock.is_connected("rock_destroyed", _on_rock_destroyed):
			rock.connect("rock_destroyed", _on_rock_destroyed)


func _on_laser_hit_object(body):
	body.destroy()


func _on_rock_destroyed(pos, rock_type, points):
	if rock_type == 0:
		spawn_small_rock(pos)
		spawn_small_rock(pos)
	if rock_type == 1:
		spawn_big_rock()
	
	update_score_by(points)


func spawn_small_rock(pos):
	var rock = small_rock.instantiate()
	rock.global_position = pos
	rocks_node.call_deferred("add_child", rock)


func spawn_big_rock():
	var rock = big_rock.instantiate()
	rock.global_position = Vector2(-100, randi() % 1000)
	rocks_node.call_deferred("add_child", rock)


func update_score_by(points: int):
	_score += points
	_update_score_display()


func reset_score():
	_score = 0
	_update_score_display()


func _update_score_display():
	score.text = "Score: %s" % [_score]


# the player has collided with a rock
func _on_player_body_entered(_body):
	player.destroy_ship()


# player destroyed, restart the game
func _on_player_player_destroyed(_player_position):
	restart_timer.start()


func _on_restart_timer_timeout():
	get_tree().reload_current_scene()
