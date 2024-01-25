extends CharacterBody2D

const SPEED = 300.0  # Velocidade constante do personagem
const JUMP_VELOCITY = -400.0  # Força do pulo do personagem

# Obtém a gravidade das configurações do projeto para sincronizar com os nós RigidBody.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D  # Sprite animado do personagem
var is_jumping := false  # Variável para verificar se o personagem está pulando

func _physics_process(delta):
	# Obtém a direção do input do usuário
	var direction = Input.get_axis("move_left", "move_right")
	# Atualiza a velocidade do personagem baseado na direção
	velocity.x = direction * SPEED
	# Atualiza a escala do sprite baseado na direção
	sprite.scale.x = direction if direction != 0 else sprite.scale.x

	# Se o personagem não está no chão, aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Se o personagem está no chão e a velocidade vertical não é zero, define que não está pulando
		if velocity.y != 0:
			is_jumping = false
		# Reseta a velocidade vertical
		velocity.y = 0

	# Se o botão de pulo foi pressionado e o personagem está no chão, aplica a força do pulo
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	# Se o personagem está no chão, verifica a direção para tocar a animação correta
	if is_on_floor():
		if direction != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	# Se o personagem está subindo, toca a animação de pulo
	elif velocity.y < 0:
		sprite.play("jump")
	# Se o personagem está caindo, toca a animação de queda
	elif velocity.y > 0:
		sprite.play("fall")

	# Aplica o movimento ao personagem
	move_and_slide()