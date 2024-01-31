extends CharacterBody2D

const SPEED = 5000.0

@onready var detector := $RayCast2D as RayCast2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D

var direction := -1  # Inicialmente indo para a esquerda VARIAVEL 1 LIGADA AO METADADO
var knockback_vector = Vector2()
# Obtenha a gravidade das configurações do projeto para ser sincronizado com os nós RigidBody.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if has_meta("Direita") and get_meta("Direita"):
		direction = 1  # Começa indo para a direita devido à metadado "Direita" ativo
		detector.scale.x *= -1
		sprite.flip_h = direction == 1  # Atualiza a orientação do sprite quando a direção muda
	elif detector.is_colliding():
		direction *= -1  # Comporta-se normalmente com as colisões
		detector.scale.x *= -1
		sprite.flip_h = direction == 1  # Atualiza a orientação do sprite quando a direção muda
	
func _physics_process(delta):
	# Adicione a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding():
		direction *= -1
		detector.scale.x *= -1
		sprite.flip_h = direction == 1  # Atualiza a orientação do sprite quando a direção muda

	velocity.x = direction * SPEED * delta
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "hurt": 
		queue_free()
		
