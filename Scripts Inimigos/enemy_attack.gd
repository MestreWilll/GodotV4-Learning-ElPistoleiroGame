extends CharacterBody2D

var move_speed := 50.0
var direction := 1
@onready var sprite = $sprite
@onready var ground_detector = $ground_detector
@onready var player_detector_left = $player_detector_left
@onready var player_detector_right = $player_detector_right
@onready var spawn_bullet = $spawn_bullet
@onready var shoot_delay_timer = $shoot_delay_timer
@onready var animation_timer = $animation_timer

const LAYER_MUNDO := 1
const LAYER_PLATAFORMAS := 2
const BULLET_ENEMY_SCENE = preload("res://Inimigos_cenario/bullet_enemy.tscn")
var gravity := 300
var velocity_y := 0.0
var bullet_speed := 200.0
@export var score_contagem := 100
var in_hurt_animation := false
var score_given := false
var hurt = false

func _ready() -> void:
	shoot_delay_timer.wait_time = 1.5
	shoot_delay_timer.one_shot = true

func _process(_delta):
	if is_on_wall():
		flip_enemy()
	
	# Aplica gravidade constantemente
	velocity_y += gravity * _delta
	
	# Verifica se está no chão para parar a aplicação da gravidade
	if ground_detector.is_colliding():
		if velocity_y > 0:
			velocity_y = 0
	
	velocity.x = move_speed * direction
	velocity.y = velocity_y
	
	check_player_detection()
	
	# move_and_slide agora inclui a direção do vetor normal do chão
	move_and_slide()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	# Ajusta a posição do spawn_bullet para corresponder à nova direção
	spawn_bullet.position.x = -spawn_bullet.position.x

func check_player_detection():
	var shoot_direction = 0
	if player_detector_left.is_colliding():
		shoot_direction = -1
	elif player_detector_right.is_colliding():
		shoot_direction = 1
	
	if shoot_direction != 0:
		if direction != shoot_direction:
			flip_enemy()
		if shoot_delay_timer.is_stopped():
			sprite.play("shoot")
			animation_timer.start(1.5) # Inicia o timer com a duração desejada da animação de tiro
			spawn_bullet_enemy(shoot_direction)
	else:
		if sprite.animation != "run_shoot":
			sprite.play("run_shoot")

func spawn_bullet_enemy(_shoot_direction):
	var new_bullet = BULLET_ENEMY_SCENE.instantiate()
	add_child(new_bullet)
	
	new_bullet.global_position = spawn_bullet.global_position
	new_bullet.set_direction(direction)
	new_bullet.velocity = Vector2(bullet_speed * direction, 0)
	shoot_delay_timer.start()

		
func play_hurt_animation():
	remove_from_group("enemies") # Remove o inimigo do grupo para evitar causar dano
	sprite.play("hurt")
	if not score_given:
		Game.score += score_contagem
		score_given = true
	collision_layer &= ~(1 << 2) # Desativa a camada de colisão 3 (Inimigos)
	collision_mask &= ~(1 << 2) # Desativa a máscara de colisão 3 (Inimigos)
	collision_layer &= ~(1 << 5) # Desativa a camada de colisão 6 (Hithurt)
	collision_mask &= ~(1 << 5) # Desativa a máscara de colisão 6 (Hithurt)
	await sprite.animation_finished
	if sprite.animation == "hurt":
		queue_free()  # Remove o inimigo após a animação
		print("Coisas concluidas de colisão no nó inimigo")		
func _on_sprite_animation_finished():
	if sprite.animation == "hurt":
		sprite.play("hurt")
		hurt = false
		print("Animação de dano concluída no nó inimigo porem o maldito não desaparece do nó")
func detonar_inimigo():
	await _on_sprite_animation_finished()
	hurt = true
	await get_tree().create_timer(0.5).timeout # Aguarda um breve momento para garantir que tudo foi processado
	if hurt == true:
		queue_free()  # Remove o inimigo após a animação
func is_in_hurt_animation() -> bool:
	return sprite.current_animation == "hurt"
