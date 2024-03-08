extends CharacterBody2D

var move_speed := 50.0
var direction := 1
var health_points := 3
@onready var sprite = $sprite
@onready var ground_detector = $ground_detector
@onready var player_detector_left = $player_detector_left
@onready var player_detector_right = $player_detector_right
@onready var spawn_bullet = $spawn_bullet

# Variável exportada para controlar o comportamento de gravidade
@export var gravity_mode := 1

# Constantes para as camadas de colisão
const LAYER_MUNDO := 1
const LAYER_PLATAFORMAS := 2
const BULLET_ENEMY_SCENE = preload("res://Inimigos_cenario/bullet_enemy.tscn")
# Variáveis para gravidade e velocidade vertical
var gravity := 300
var velocity_y := 0.0

func _process(delta):
	if is_on_wall():
		flip_enemy()
		 
	if !ground_detector.is_colliding():
		if gravity_mode == 1:
			# Aplica gravidade se não estiver colidindo com o chão
			velocity_y += gravity * delta
		elif gravity_mode == 2:
			# Se estiver no modo 2, vira o inimigo quando chegar ao fim da plataforma
			flip_enemy()
	else:
		# Reseta a velocidade vertical se estiver no chão
		velocity_y = 0
	
	# Aplica a direção horizontal
	velocity.x = move_speed * direction
	
	# Atualiza a posição vertical com a velocidade vertical
	velocity.y = velocity_y
	# Move e aplica a gravidade se necessário
	
	if player_detector_left.is_colliding():
		spawn_bullet_enemy(-1) # Esquerda
	if player_detector_right.is_colliding():
		spawn_bullet_enemy(1) # Direita
		
	move_and_slide()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	# Se estiver no modo de gravidade 1, não vira o detector de chão
	if gravity_mode == 1:
		player_detector_left.scale.x *= -1
		player_detector_right.scale.x *= -1
		spawn_bullet.position.x *= -1
		
		
func spawn_bullet_enemy(direction):
	var new_bullet = BULLET_ENEMY_SCENE.instantiate()
	add_child(new_bullet)
	new_bullet.global_position = spawn_bullet.global_position
	new_bullet.direction = direction # Assumindo que a cena da bala tem uma variável 'direction' para controlar sua direção
