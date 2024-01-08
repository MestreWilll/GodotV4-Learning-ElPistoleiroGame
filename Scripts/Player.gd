extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const IDLE_ANIMATION = "idle2"
const RUN_ANIMATION = "run"
const JUMP_ANIMATION = "jump"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
# Não há necessidade de declarar 'up_direction' aqui, pois já é uma propriedade de CharacterBody2D.

func _ready():
    # Ajustar a direção 'up' diretamente na propriedade herdada, se necessário.
    self.up_direction = Vector2.UP

func _physics_process(delta):
    # Add the gravity if the character is not on the floor.
    if not is_on_floor():
        self.velocity.y += gravity * delta
        $AnimationPlayer.play(JUMP_ANIMATION)
    else:
        if self.velocity.x == 0:
            $AnimationPlayer.play(IDLE_ANIMATION)

    # Handle Jumping.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        self.velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    var direction = Input.get_axis("ui_left", "ui_right")
    if direction:
        self.velocity.x = direction * SPEED
        $AnimationPlayer.play(RUN_ANIMATION)
        # Flip the sprite based on the direction.
        if direction > 0 and not facing_right:
            flip_h()
        elif direction < 0 and facing_right:
            flip_h()
    else:
        # Decelerate the character when not receiving input.
        self.velocity.x = move_toward(self.velocity.x, 0, SPEED * delta)
        if is_on_floor():
            $AnimationPlayer.play(IDLE_ANIMATION)

    # Move the character and slide along the floor.
    move_and_slide(self.velocity, up_direction)

func flip_h():
    facing_right = !facing_right
    $Sprite.flip_h = facing_right
