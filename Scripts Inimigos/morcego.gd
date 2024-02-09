extends CharacterBody2D

const SPEED = 80.0
const CHANGE_DIRECTION_MIN = 2.0  # Tempo mínimo para mudança de direção
const CHANGE_DIRECTION_MAX = 5.0  # Tempo máximo para mudança de direção

@onready var detector := $RayCast2D as RayCast2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@export var score_contagem := 50

var direction := -1  # Inicialmente indo para a esquerda
var time_to_change_direction := randf_range(CHANGE_DIRECTION_MIN, CHANGE_DIRECTION_MAX)  # Tempo até a próxima mudança de direção

func _ready():
	randomize()  # Inicializa o gerador de números aleatórios
	if has_meta("Direita2") and get_meta("Direita2"):
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

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "hurt": 
		
		queue_free()
		print("hurt aqui")

func play_hurt_animation():
	remove_from_group("enemies")  # Remove o inimigo do grupo para evitar causar dano
	sprite.play("hurt")
	Game.score += score_contagem
	# Aguarda o fim da animação "hurt" antes de remover o inimigo
	await sprite.animation_finished
	if sprite.animation == "hurt":
		queue_free()  # Remove o inimigo após a animação
