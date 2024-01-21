extends CharacterBody2D

const SPEED = 300.0
const CHANGE_DIRECTION_MIN = 1.0  # Tempo mínimo para mudança de direção
const CHANGE_DIRECTION_MAX = 3.0  # Tempo máximo para mudança de direção

@onready var detector := $RayCast2D as RayCast2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D

var direction := -1  # Inicialmente indo para a esquerda
var time_to_change_direction := randf_range(CHANGE_DIRECTION_MIN, CHANGE_DIRECTION_MAX)  # Tempo até a próxima mudança de direção

func _ready():
	randomize()  # Inicializa o gerador de números aleatórios
	if has_meta("Direita") and get_meta("Direita"):
		direction = 1
		detector.scale.x *= -1
		sprite.flip_h = direction == 1  # Atualiza a orientação do sprite quando a direção muda

func _physics_process(delta):
	# Atualiza o temporizador e muda a direção se necessário.
	time_to_change_direction -= delta
	if time_to_change_direction <= 0:
		direction *= -1
		time_to_change_direction = randf_range(CHANGE_DIRECTION_MIN, CHANGE_DIRECTION_MAX)

	# Verifica colisões e muda a direção se colidir.
	if detector.is_colliding():
		direction *= -1

	# Atualiza a escala e a orientação do sprite com base na direção.
	detector.scale.x = direction
	sprite.flip_h = direction == 1

	# Calcula a nova posição horizontal.
	var horizontal_movement = direction * SPEED * delta

	# Move o morcego diretamente, atualizando sua posição.
	position.x += horizontal_movement