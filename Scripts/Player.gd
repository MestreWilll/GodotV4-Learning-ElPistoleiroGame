class_name Player extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -530.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D

var is_running = false
var is_jumping = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("jump")
	# Handle movement and animations.

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animation.scale.x = direction
	if Input.is_action_pressed("move_right"):
		direction = 1.0
		is_running = true
	elif Input.is_action_pressed("move_left"):
		direction = -1.0
		is_running = true
	else:
		is_running = false

	if is_running:
		velocity.x = direction * SPEED
		animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
	move_and_slide()
