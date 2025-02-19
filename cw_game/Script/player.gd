extends Area2D
signal hit

@onready var animate = $AnimatedSprite2D
@onready var player_coll = $CollisionShape2D

@export var speed = 400

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_r"):
		velocity.x += 1
		animate.flip_h = false
	if Input.is_action_pressed("move_l"):
		velocity.x -= 1
		animate.flip_h = true
	if Input.is_action_pressed("move_d"):
		velocity.y += 1
		animate.flip_v = true
	if Input.is_action_pressed("move_u"):
		velocity.y -= 1
		animate.flip_v = false
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		animate.play(animate_manage(velocity))
	else:
		animate.flip_v = false
		animate.flip_h = false
		animate.stop()
		
func animate_manage(vel):
	var animate_p = "Walk"
	if vel.x != 0:
		animate_p = "Walk"
	elif vel.y != 0:
		animate_p = "Up"
	return animate_p
	
func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	player_coll.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	player_coll.disabled = false
