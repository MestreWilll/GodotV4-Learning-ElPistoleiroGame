extends CharacterBody2D

const SPEED = 5000.0
const JUMP_VELOCITY = -450.0

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $ray_left
@onready var detectorR = $ray_right

var direction := 1  # Inicialmente indo para a direita (1 para direita, -1 para esquerda)
var knockback_vector = Vector2()
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _ready():
	if has_meta("Direita") and get_meta("Direita"):
		direction = -1  # Começa indo para a direita devido à metadado "Direita" ativo
		detector.scale.x *= -1
		sprite.flip_h = direction == -1  # Atualiza a orientação do sprite quando a direção muda
	elif detector.is_colliding():
		direction *= -1  # Comporta-se normalmente com as colisões
		detector.scale.x *= -1
		sprite.flip_h = direction == 1  # Atualiza a orientação do sprite quando a direção muda

func _physics_process(delta):
	# Adicione a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding() or detectorR.is_colliding():
		direction *= -1  # Inverte a direção quando qualquer um dos detectores colide
		sprite.flip_h = direction == -1  # Atualiza o flip_h baseado na nova direção

	velocity.x = direction * SPEED * delta
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "hurt": 
		queue_free()
		print("hurt aqui")
