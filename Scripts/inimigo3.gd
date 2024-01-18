extends CharacterBody2D


const SPEED = 10300.0
const JUMP_VELOCITY = -400.0

@onready var detector := $RayCast2D as RayCast2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D

var direction := -1

# Obtenha a gravidade das configurações do projeto para ser sincronizado com os nós RigidBody.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Adicione a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding():
		direction *= -1
		detector.scale.x *= -1
		
	if direction == 1:
		sprite.flip_h = true
	else: 
		sprite.flip_h = false
	velocity.x = direction * SPEED * delta

	move_and_slide()
