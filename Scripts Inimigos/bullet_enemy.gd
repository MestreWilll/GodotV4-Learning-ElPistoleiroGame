extends CharacterBody2D

var move_speed := 250
var direction := 1 
@onready var anim_bullet_enemy = $anim_bullet_enemy

func _ready():
	# Ajusta a orientação do projétil com base na direção inicial.
	anim_bullet_enemy.flip_h = direction < 0

func _process(delta):
	position.x += move_speed * direction * delta

func set_direction(dir):
	direction = dir
	anim_bullet_enemy.flip_h = dir < 0
