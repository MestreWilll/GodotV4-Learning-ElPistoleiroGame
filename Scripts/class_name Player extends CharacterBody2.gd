class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var action_suffix := ""

var idle_animation: String = "idle" + action_suffix
var jump_animation: String = "jump" + action_suffix
var run_animation: String = "run" + action_suffix

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var camera := $Camera as Camera2D

var _double_jump_charged: bool = false  # Assuming you have this variable declared somewhere

func _physics_process(delta: float) -> void:
    if is_on_floor():
        _double_jump_charged = true
    if Input.is_action_just_pressed("jump" + action_suffix):
        try_jump()
    elif Input.is_action_just_released("jump" + action_suffix) and velocity.y < 0.0:
        # The player let go of jump early, reduce vertical momentum.
        velocity.y *= 0.6
    # Fall.
    velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)

    var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * SPEED
    velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)

    if not is_zero_approx(velocity.x):
        if velocity.x > 0.0:
            sprite.scale.x = 1.0
        else:
            sprite.scale.x = -1.0

    floor_stop_on_slope = not platform_detector.is_colliding()
    move_and_slide()

    var animation := get_new_animation(is_shooting)
    if animation != animation_player.current_animation and shoot_timer.is_stopped():
        if is_shooting:
            shoot_timer.start()
        animation_player.play(animation)

func get_new_animation(is_shooting := false) -> String:
    var animation_new: String
    if is_on_floor():
        if absf(velocity.x) > 0.1:
            animation_new = run_animation
        else:
            animation_new = idle_animation
    else:
        if velocity.y > 0.0:
            animation_new = "falling"  # Make sure you have this animation defined
        else:
            animation_new = jump_animation
    return animation_new

func try_jump() -> void:
    if is_on_floor():
        jump_sound.pitch_scale = 1.0  # Assuming you have a jump_sound variable
    elif _double_jump_charged:
        _double_jump_charged = false
        velocity.x *= 2.5
        jump_sound.pitch_scale = 1.5
    else:
        return

    velocity.y = JUMP_VELOCITY
    jump_sound.play()  # Make sure you have a jump_sound variable