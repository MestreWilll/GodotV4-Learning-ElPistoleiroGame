extends CharacterBody2D

const SPEED = 180.0  # Velocidade constante do personagem
const JUMP_VELOCITY = -450.0  # Força do pulo do personagem
const BULLET_SCENE = preload("res://Inimigos_cenario/bullet.tscn")


# Obtém a gravidade das configurações do projeto para sincronizar com os nós CharacterBody2D.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform = $remote as RemoteTransform2D  # Transformação remota para seguir a câmera
@onready var ray_left = $RayCast2D_Left as RayCast2D  # Raycast para detecção de colisão à esquerda
@onready var ray_right = $RayCast2D_Right as RayCast2D
@onready var ray_detector = $RayCast2D_detector as RayCast2D  # Raycast para detecção de colisão à direita
@onready var shoot_cooldown = $shoot_cooldown
@onready var bullet_position = $bullet_position


var knockback_vector = Vector2()  # Vetor de knockback para empurrar o personagem quando atingido
var is_running = false  # Variável para rastrear se o personagem está correndo
var is_jumping = false  # Variável para rastrear se o personagem está pulando
var is_shooting = false  # Variável para rastrear se o personagem está atirando
		# Aqui você pode adicionar lógica adicional, como desativar o script ou carregar o nó dinamicamente.
func _physics_process(delta):
##--------------------------##
## Movimentos personagem ##
##--------------------------##
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("move_left"):
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1
			
	if Input.is_action_pressed("move_right"):
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1
	# Atualiza a velocidade do personagem baseado na direção
	velocity.x = direction * SPEED
	# Atualiza a escala do sprite baseado na direção
	# Atualiza a escala do sprite baseado na direção
	if sprite and direction != 0:  # Verifica se o sprite não é null e se a direção é diferente de zero
		sprite.scale.x = direction

	# Se o personagem não está no chão, aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Se o personagem está no chão e a velocidade vertical não é zero, define que não está pulando
		if velocity.y != 0:
			is_jumping = false
		# Reseta a velocidade vertical para zero
		velocity.y = 0

	# Se o botão de pulo foi pressionado e o personagem está no chão, aplica a força do pulo
	if Input.is_action_pressed("ui_jump") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")
	# Verifica se o botão de atirar está sendo pressionado
	if Input.is_action_pressed("ui_shoot"):
		is_shooting = true
		shoot_bullet()
		sprite.play("shoot")
	else:
		is_shooting = false

	# Se o personagem está no chão e não está atirando, toca a animação correta baseada na direção
	if is_on_floor() and not is_shooting:
		if direction != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	# Se o personagem está subindo e não está atirando, toca a animação de pulo
	elif velocity.y < 0 and not is_shooting:
		sprite.play("jump")
	# Se o personagem está caindo e não está atirando, toca a animação de queda
	elif velocity.y > 0 and not is_shooting:
		sprite.play("fall")
##--------------------------##FINISHIM##
## Finalização dos movimentos ##
##--------------------------##FINISHIM##
	# Aplica o movimento ao personagem usando a função move_and_slide
	move_and_slide()

##--------------------------##
## Movimentações dos mobs e inimigos ##
##--------------------------##
	# Aplica o knockback se necessário
	if knockback_vector.length() > 0:
		position += knockback_vector * delta
		# Amortece o knockback_vector para que o efeito diminua ao longo do tempo
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, 1000 * delta)  # Ajuste a taxa de amortecimento conforme necessário

	# Verifica se o raycast à esquerda detecta algo e executa a lógica de colisão
	if ray_left.is_enabled() and ray_left.is_colliding():
		var collider = ray_left.get_collider()
		print("Colisão detectada à esquerda com: ", collider.name)
		handle_collision(collider, "left")

	# Verifica se o raycast à direita detecta algo e executa a lógica de colisão
	if ray_right.is_enabled() and ray_right.is_colliding():
		var collider = ray_right.get_collider()
		print("Colisão detectada à direita com: ", collider.name)
		handle_collision(collider, "right")


		
func _on_hurtbox_body_entered(body):
	# Lógica para quando o personagem é atingido por um inimigo
	if body.is_in_group("enemies"):
		# Calcula a direção do knockback baseado na posição relativa do inimigo
		var knockback_direction = global_position.direction_to(body.global_position)
		# Inverte a direção para que o jogador seja empurrado para longe do inimigo
		knockback_direction = -knockback_direction
		# Define o vetor de knockback com uma magnitude maior
		knockback_vector = knockback_direction * 300  # Aumente a magnitude conforme necessário
		
		# Muda a cor do jogador para vermelho para indicar dano
		sprite.modulate = Color(1, 0, 0, 1)
		
		# Aplica o knockback após um curto período de tempo
		await get_tree().create_timer(0.1).timeout
		position += knockback_vector

		# Retorna a cor do jogador para normal após um curto período de tempo
		await get_tree().create_timer(0.2).timeout  # Ajuste a duração conforme necessário
		sprite.modulate = Color(1, 1, 1, 1)  # Cor branca (normal)

		print("Você tomou dano")

func _on_animated_sprite_2d_animation_finished():
	pass # Substitua pelo corpo da função conforme necessário.

func handle_collision(collider, direction):
	# Lógica para quando uma colisão é detectada com um inimigo
	if collider.is_in_group("enemies"):
		print("Inimigo detectado à " + direction)
		# Aqui você pode adicionar a lógica específica para quando um inimigo é detectado
		# por exemplo, aplicar knockback na direção oposta
##--------------------------##FINISHIM##
## Movimentações dos mobs e inimigos ##a
##--------------------------##FINISHIM##

##--------------------------##
## Configuração da camera que é lidada a Mundo.gd ##
##--------------------------##
func follow_camera(camera):
	# Obtém o caminho do nó da câmera e define o caminho remoto para seguir a câmera
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

# Exemplo de como chamar a função follow_camera
# Deve ser chamado em um local apropriado, como no _ready ou em uma função de configuração de cena
	var camera_node = get_node_or_null("Camera2D")
	if camera_node:
		follow_camera(camera_node)
##--------------------------##FINISHIM##
## Fim da camera ##
##--------------------------##FINISHIM##

##--------------------------##
## Area do tiro do player - Irá mexer no shoot da animação de shoot ##
##--------------------------##
func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	if sign(bullet_position.position.x) == 1:
		bullet_instance.set_direction(1)
	else:
		bullet_instance.set_direction(-1)
		
	add_child(bullet_instance)
	bullet_instance.global_position = bullet_position.global_position

