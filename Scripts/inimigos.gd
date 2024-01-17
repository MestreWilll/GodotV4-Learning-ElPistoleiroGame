extends CharacterBody2D

const SPEED = 10900.0
const JUMP_VELOCITY = -400.0

@onready var detector := $detector as RayCast2D
@onready var sprite := $sprite as Sprite2D  # Certifique-se de que o caminho para o Sprite está correto

var direction := -1

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Adiciona a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding():
		direction *= -1
		sprite.flip_h = !sprite.flip_h  # Espelha o sprite horizontalmente
		# Inverte a direção do cast_to do RayCast2D
		detector.cast_to.x *= -1

	# Atualiza a direção da velocidade horizontal.
	velocity.x = direction * SPEED * delta

	# Chama move_and_slide sem argumentos, assumindo que ele usa uma variável de instância interna.
	move_and_slide()
