extends CharacterBody2D


const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var camera := $camera as Camera2D
var is_jumping := false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		sprite.play("jump")
	elif is_on_floor():
		is_jumping = false
		
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.scale.x = direction
		if !is_jumping:
			sprite.play("run")
	elif is_jumping: 
		sprite.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")
	

	move_and_slide()
