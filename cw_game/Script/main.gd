extends Node2D

@onready var Player = $Area2D
@onready var Enemy = $RigidBody2D
@onready var MobTimer = $Timer/MobTimer
@onready var ScoreTimer = $Timer/ScoreTimer
@onready var StartTimer = $Timer/StartTimer
@onready var Start_pos = $Start_pos
@onready var mob_spawn_location = $Enemy_Path/PathFollow2D


@export var mob_scene: PackedScene

var score

func _ready() -> void:
	new_game()

func _process(delta: float) -> void:
	pass
	
func game_over():
	ScoreTimer.stop()
	MobTimer.stop()
	
func new_game():
	score = 0
	Player.start(Start_pos.position)
	StartTimer.start()

func _on_score_timer_timeout():
	score += 1
	
func _on_start_timer_timeout():
	MobTimer.start()
	ScoreTimer.start()
	
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
