class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var action_suffix := ""

var idle_animation: String = "idle" + action_suffix
var jump_animation: String = "jump" + action_suffix
var run_animation: String = "run" + action_suffix

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var Animation_player := $AnimationPlayer as AnimationPlayer
@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var Camera := $Camera as Camera2D

func _physics_process(delta: float) -> void:
	var local_velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		local_velocity.x += SPEED
		animation.play(run_animation)
	elif Input.is_action_pressed("ui_left"):
		local_velocity.x -= SPEED
		animation.play(run_animation)
	else:
		animation.play(idle_animation)
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		local_velocity.y = JUMP_VELOCITY
		animation.play(jump_animation)

	local_velocity.y += gravity * delta