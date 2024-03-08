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

func _ready() -> void:
	shoot_delay_timer.wait_time = 1.5
	shoot_delay_timer.one_shot = true
	#sprite.connect("animation_finished", Callable(self, "_on_sprite_animation_finished"))

func _process(_delta):
	if is_on_wall():
		flip_enemy()
	
	if !ground_detector.is_colliding():
		flip_enemy()
	else:
		velocity_y = 0
	
	velocity.x = move_speed * direction
	velocity.y = velocity_y
	
	check_player_detection()
	
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
			animation_timer.start(1.5)  # Inicia o timer com a duração desejada da animação de tiro
			spawn_bullet_enemy(shoot_direction)
	else:
		if sprite.animation != "run":
			sprite.play("run")

func _on_AnimationTimer_timeout():
	# Aqui você pode ajustar o que acontece após a animação de tiro
	if not player_detector_left.is_colliding() and not player_detector_right.is_colliding():
		sprite.play("run")

func _on_sprite_animation_finished():
	# Aqui você pode definir o que acontece quando a animação termina
	# Por exemplo, você pode querer mudar para uma animação de 'idle' ou 'run'
	if sprite.animation == "shoot":
		sprite.play("run")
		
func spawn_bullet_enemy(_shoot_direction):
	var new_bullet = BULLET_ENEMY_SCENE.instantiate()
	add_child(new_bullet)
	
	new_bullet.global_position = spawn_bullet.global_position
	new_bullet.set_direction(direction)
	new_bullet.velocity = Vector2(bullet_speed * direction, 0)
	shoot_delay_timer.start()


