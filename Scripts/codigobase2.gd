class_name Inimigos extends CharacterBody2D

const SPEED = 10280.0
const JUMP_VELOCITY = -530.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $RayCast2D as RayCast2D

var is_colliging = false
var direction: int = -1
	
func _physics_process(delta):
	# Adiciona a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding():
		direction *= -1
		
	velocity.x = direction * SPEED * delta

	move_and_slide()
