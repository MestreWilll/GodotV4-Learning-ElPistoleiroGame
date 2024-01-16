class_name Player extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -530.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D

var is_running = false
var is_jumping = false
var is_shooting = false  # Adiciona uma variável para rastrear o estado de atirar

func _physics_process(delta):
	# Adiciona a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Manipula o pulo.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("jump")

	# Manipula o movimento e as animações.
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animation.scale.x = direction
	if Input.is_action_pressed("move_right"):
		direction = 1.0
		is_running = true
	elif Input.is_action_pressed("move_left"):
		direction = -1.0
		is_running = true
	else:
		is_running = false

	# Inicia a animação "shoot" quando a tecla F é pressionada.
	if Input.is_action_pressed("ui_shoot") and not is_shooting:
		is_shooting = true
		animation.play("shoot")
	# Para a animação "shoot" quando a tecla F é solta.
	elif not Input.is_action_pressed("ui_shoot") and is_shooting:
		is_shooting = false
		animation.stop()
		animation.frame = 4  # Retorna para o primeiro quadro da animação

	# Se o jogador não estiver atirando, manipula as animações de corrida e ocioso.
	if not is_shooting:
		if is_running:
			velocity.x = direction * SPEED
			if animation.animation != "run":
				animation.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if animation.animation != "idle":
				animation.play("idle")

	move_and_slide()
