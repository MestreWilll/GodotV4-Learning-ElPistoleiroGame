extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -550.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform = $remote as RemoteTransform2D
@onready var ray_left = $RayCast2D_Left as RayCast2D
@onready var ray_right = $RayCast2D_Right as RayCast2D
var knockback_vector = Vector2()
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

	# Aplica o knockback se necessário
	if knockback_vector.length() > 0:
		position += knockback_vector * delta
		# Amortece o knockback_vector para que o efeito diminua ao longo do tempo
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, 1000 * delta)  # Ajuste a taxa de amortecimento conforme necessário

	# Verifica se o raycast à esquerda detecta algo, apenas uma referencia
	if ray_left.is_enabled() and ray_left.is_colliding():
		var collider = ray_left.get_collider()
		print("Colisão detectada à esquerda com: ", collider.name)
		# Lógica para quando algo é detectado à esquerda
		handle_collision(collider, "left")

	# Verifica se o raycast à direita detecta algo
	if ray_right.is_enabled() and ray_right.is_colliding():
		var collider = ray_right.get_collider()
		print("Colisão detectada à direita com: ", collider.name)
		# Lógica para quando algo é detectado à direita
		handle_collision(collider, "right")

	move_and_slide()

func follow_camera(camera):
	var camera_path = camera.get_path()  # Supondo que você queria obter o caminho do nó da câmera
	remote_transform.remote_path = camera_path

# Exemplo de como chamar follow_camera
# Isso deve ser chamado em algum lugar apropriado no seu script, como no _ready ou em uma função que configura a cena

	# Supondo que você tenha um nó de câmera na sua cena chamado "Camera2D"
	var camera_node = get_node_or_null("Camera2D")
	if camera_node:
		follow_camera(camera_node)
		
# Isso está assumindo que você tem uma referência ao objeto Player chamado 'player_instance'
func _on_hurtbox_body_entered(body):
	if body.is_in_group("enemies"):
		# Calcula a direção do knockback baseado na posição relativa do inimigo
		var knockback_direction = global_position.direction_to(body.global_position)
		# Inverte a direção para que o jogador seja empurrado para longe do inimigo
		knockback_direction = -knockback_direction
		# Define o vetor de knockback com uma magnitude maior
		knockback_vector = knockback_direction * 300  # Aumente a magnitude conforme necessário
		
		# Muda a cor do jogador para vermelho
		animation.modulate = Color(1, 0, 0, 1)
		
		# Aplica o knockback após um curto período de tempo
		await get_tree().create_timer(0.1).timeout
		position += knockback_vector

		# Retorna a cor do jogador para normal após um curto período de tempo
		await get_tree().create_timer(0.2).timeout  # Ajuste a duração conforme necessário
		animation.modulate = Color(1, 1, 1, 1)  # Cor branca (normal)

		print("Vc tomou dano")

func _on_animated_sprite_2d_animation_finished():
	pass # Replace with function body.

func handle_collision(collider, direction):
	if collider.is_in_group("enemies"):
		# Aqui você pode adicionar a lógica específica para quando um inimigo é detectado
		# por exemplo, aplicar knockback na direção oposta
		print("Inimigo detectado à " + direction)
