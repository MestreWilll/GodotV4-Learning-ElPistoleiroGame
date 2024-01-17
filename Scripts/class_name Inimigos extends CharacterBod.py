class_name Inimigos extends CharacterBody2D

const SPEED = 10280.0
const JUMP_VELOCITY = -530.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $RayCast2D as RayCast2D
@onready var colison = $CollisionShape2D as CollisionObject2D


var direction: int = -1
	
func _physics_process(delta):
	# Adiciona a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding():
		print("Colisão detectada, invertendo direção.")
		direction *= -1
		animation.flip_h = !animation.flip_h  # Espelha o sprite horizontalmente
		# Inverte a direção do cast_to do RayCast2D
		detector.cast_to.x *= -1
		
	velocity.x = direction * SPEED * delta

	move_and_slide()