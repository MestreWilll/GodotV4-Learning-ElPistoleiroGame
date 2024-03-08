extends CharacterBody2D

var move_speed := 100
var direction := 1
@onready var sprite = $sprite

func _physics_process(_delta):
	velocity.x = move_speed * direction
	move_and_slide()

func set_direction(dir):
	direction = dir
	if dir < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
