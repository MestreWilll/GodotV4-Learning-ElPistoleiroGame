extends CharacterBody2D

const SPEED = 10900.0

@onready var detector := $detector as RayCast2D
@onready var sprite := $sprite as Sprite2D

var direction := -1  # Inicialmente indo para a esquerda

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Calcula a velocidade horizontal.
	linear_velocity.x = direction * SPEED

	# Verifica se está no chão para aplicar a gravidade.
	if is_on_floor():
		linear_velocity.y = 0
	else:
		linear_velocity.y += gravity * delta

	if detector.is_colliding():
		direction *= -1
		# Espelha o sprite horizontalmente baseado na direção
		sprite.flip_h = direction < 0

	# Chama move_and_slide() que agora usa a propriedade linear_velocity.
	move_and_slide()
