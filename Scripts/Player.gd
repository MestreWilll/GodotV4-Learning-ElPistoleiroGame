extends CharacterBody2D
##PRIME

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const IDLE_ANIMATION = "idle2"
const RUN_ANIMATION = "run"
const JUMP_ANIMATION = "jump"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimationPlayer.play(JUMP_ANIMATION)
	else:
		if velocity.x == 0:
			$AnimationPlayer.play(IDLE_ANIMATION)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimationPlayer.play(RUN_ANIMATION)
		# Flip the sprite based on the direction.
		if direction > 0 and not facing_right:
			flip_h()
		elif direction < 0 and facing_right:
			flip_h()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimationPlayer.play(IDLE_ANIMATION)

	move_and_slide(velocity, Vector2.UP)

func flip_h():
	facing_right = !facing_right
	$Sprite.flip_h = facing_right
