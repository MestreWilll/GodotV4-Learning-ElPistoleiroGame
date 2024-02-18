extends CharacterBody2D

const SPEED = 5000.0
const JUMP_VELOCITY = -450.0

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $ray_left
@onready var detectorR = $ray_right
@export var score_contagem := 100
@export var direcao_inicial := 1 # Adiciona esta linha

var direction := 1
var knockback_vector = Vector2()
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	direction = direcao_inicial # Define a direção inicial aqui
	sprite.flip_h = direction == -1 # Atualiza o flip_h baseado na direção inicial

func _physics_process(delta):
	# Adicione a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding() or detectorR.is_colliding():
		direction *= -1
		sprite.flip_h = direction == -1

	velocity.x = direction * SPEED * delta
	move_and_slide()

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
