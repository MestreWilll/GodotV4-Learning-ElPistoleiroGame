extends CharacterBody2D

const SPEED = 300.0  # Velocidade constante do personagem
const JUMP_VELOCITY = -450.0  # Força do pulo do personagem
const BULLET_SCENE = preload("res://Inimigos_cenario/bullet.tscn")
@export var direction_capt = 0

# Obtém a gravidade das configurações do projeto para sincronizar com os nós CharacterBody2D.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform = $remote as RemoteTransform2D  # Transformação remota para seguir a câmera
@onready var ray_left = $RayCast2D_Left as RayCast2D  # Raycast para detecção de colisão à esquerda
@onready var ray_right = $RayCast2D_Right as RayCast2D
@onready var ray_detector = $RayCast2D_detector as RayCast2D  # Raycast para detecção de colisão à direita
@onready var shoot_cooldown = $shoot_cooldown
@onready var bullet_position = $bullet_position
@onready var shoot_delay_timer = $ShootDelayTimer
@onready var Player = $"."
@onready var hud_manager_node = get_node("../Controls/Control")
@onready var platform_pass_timer = $PlatformPassTimer
@onready var player_area2D = %PlayerArea2D
@onready var phantom_camera_2d = %PhantomCamera2D

var knockback_vector = Vector2()  # Vetor de knockback para empurrar o personagem quando atingido
var is_running = false  # Variável para rastrear se o personagem está correndo
var is_jumping = false  # Variável para rastrear se o personagem está pulando
var is_shooting = false  # Variável para rastrear se o personagem está atirando
var can_pass_through_platforms = false  # Variável para controlar a passagem através das plataformas
var shoot_direction = 1  # Direção do tiro, 1 para direita, -1 para esquerda
var extra_jumps = 1  # Permite um pulo extra (pulo duplo)
signal player_has_died
signal game_over
signal area_entered
signal area_exited

func _ready() -> void:
	player_area2D.connect("area_entered", Callable(self, "_on_show_prompt"))
	player_area2D.connect("area_exited", Callable(self, "_on_hide_prompt"))
	Player.connect("game_over", Callable(self, "_on_game_over"))
	shoot_delay_timer.wait_time = 0.2  # Ajuste conforme necessário

		# Aqui você pode adicionar lógica adicional, como desativar o script ou carregar o nó dinamicamente.
func _physics_process(delta):
#-------------------------------------------------------------------------------------------------
##--------------------------##
## Movimentos personagem ##
##--------------------------##
	# Atualiza a direção do tiro e o flip do sprite baseado na direção de movimento
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_pressed("move_left"):
		direction_capt = direction
		shoot_direction = -1  # Define a direção do tiro para esquerda
		if direction_capt > 0:
			sprite.flip_h = true
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1

	if Input.is_action_pressed("move_right"):
		direction_capt = direction
		shoot_direction = 1  # Define a direção do tiro para direita
		sprite.flip_h = false
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1
	# Atualiza a velocidade do personagem baseado na direção
	if Input.is_action_just_pressed("down") and is_on_floor(): #botao pra sair da plataforma para baixo no caso, S 
		pass_through_platform()

	velocity.x = direction * SPEED
	# Atualiza a escala do sprite baseado na direção
	# Atualiza a escala do sprite baseado na direção
	if sprite and direction != 0:  # Verifica se o sprite não é null e se a direção é diferente de zero

		sprite.scale.x = sign(direction) * abs(sprite.scale.x)

	# Se o personagem não está no chão, aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		extra_jumps = 1
		is_jumping = false
		velocity.y = 0

	# Lógica de pulo ajustada para permitir pulo duplo
	if Input.is_action_just_pressed("ui_jump"):
		if is_on_floor() or extra_jumps > 0:
			if not is_on_floor():
				extra_jumps -= 1
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			sprite.play("jump")

	# Verifica se o botão de atirar está sendo pressionado	
	if Input.is_action_pressed("ui_shoot"):
		if not is_shooting:
			shoot_bullet()
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
#-------------------------------------------------------------------------------------------------
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
		handle_collision(collider, "left")

	# Verifica se o raycast à direita detecta algo e executa a lógica de colisão
	if ray_right.is_enabled() and ray_right.is_colliding():
		var collider = ray_right.get_collider()
		handle_collision(collider, "right")

		
func _on_hurtbox_body_entered(body):
	if body and body.is_in_group("enemies"):
		var knockback_direction = global_position.direction_to(body.global_position)
		knockback_direction = -knockback_direction
		knockback_vector = knockback_direction * 300
		sprite.modulate = Color(1, 0, 0, 1)
		
		await get_tree().create_timer(0.1).timeout
		position += knockback_vector
		
		await get_tree().create_timer(0.2).timeout
		sprite.modulate = Color(1, 1, 1, 1)
		print("Tomou dano")
		# Aqui você diminui a vida do jogador
		if Game.player_life > 0:
			Game.player_life -= 1
			hud_manager_node.update_player_life(Game.player_life)
		if Game.player_life <= 0:
			emit_signal("game_over")

func _on_animated_sprite_2d_animation_finished():
	pass # Substitua pelo corpo da função conforme necessário.

func play_hurt_animation():
	remove_from_group("enemies")  # Remove o inimigo do grupo para evitar causar dano
	sprite.play("hurt")

func handle_collision(collider, direction):
	# Lógica para quando uma colisão é detectada com um inimigo
	if collider and collider.is_in_group("enemies"):
		print("Inimigo detectado à " + direction)
	else:
		print("Colisor é nulo ou não está no grupo 'enemies'")
		# Aqui você pode adicionar a lógica específica para quando um inimigo é detectado
		# por exemplo, aplicar knockback na direção oposta
##--------------------------##FINISHIM##
## Movimentações dos mobs e inimigos ##a
##--------------------------##FINISHIM##
#-------------------------------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------------------------
##--------------------------##
## Area do tiro do player - Irá mexer no shoot da animação de shoot ##
##--------------------------##

func shoot_bullet():
	if shoot_delay_timer.is_stopped():
		var bullet_instance = BULLET_SCENE.instantiate()
		bullet_instance.direction = shoot_direction  # Aplica a direção do tiro
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = bullet_position.global_position
		shoot_delay_timer.start()
		is_shooting = true
		sprite.play("shoot")
	
func _on_shoot_delay_timer_timeout():
	is_shooting = false

##--------------------------##FINISHIM##
## shoot funcionando, agora é so configurar o time ##
##--------------------------##FINISHIM##
#-------------------------------------------------------------------------------------------------
##--------------------------##
## Configuraçõe para ultrapassar plataformas "one way" configurado no timer nó filho do player##
##--------------------------##
func pass_through_platform():
	# Ignora a camada das plataformas "One Way"
	collision_mask &= ~128  # Desativa a camada 8 na máscara de colisão
	can_pass_through_platforms = true
	platform_pass_timer.start()

func _on_platform_pass_timer_timeout():
	# Reabilita a colisão com as plataformas "One Way"
	collision_mask |= 128  # Reativa a camada 8 na máscara de colisão
	can_pass_through_platforms = false
##--------------------------##FINISHIM##
## Configuraçõe para ultrapassar plataformas "one way" configurado no timer nó filho do player##
##--------------------------##FINISHIM##

func _on_show_prompt(body):
	if body == self:
		phantom_camera_2d.set_zoom(Vector2(1.5, 1.5))  # Supondo que exista um método set_zoom

func _on_hide_prompt(body):
	if body == self:
		phantom_camera_2d.set_zoom(Vector2(5, 5))  # Supondo que exista um método set_zoom
		
