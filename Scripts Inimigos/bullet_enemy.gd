extends Area2D

var move_speed := 50
var direction := Vector2.RIGHT
@onready var sprite = $sprite
var velocity := Vector2.ZERO
const GAME_OVER_SCENE = preload("res://Menu/game_over.tscn")

func _ready():
	pass
	# Conecta o sinal area_entered, se necessário
	# connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta):
	velocity.x = move_speed * direction.x
	position += velocity * delta

func set_direction(dir):
	direction.x = dir
	sprite.flip_h = dir < 0

func _on_body_entered(body):
	if body and body.is_in_group("player"):
		# Aplica knockback ao jogador
		var knockback_direction = Vector2(global_position.direction_to(body.global_position).x, 0).normalized()
		body.apply_knockback(knockback_direction * 200)  # Aplica knockback apenas horizontalmente
		# Reduz a vida do jogador e verifica a condição de game over
		Game.player_life -= 1
		print("Jogador tomou dano. Vida restante: ", Game.player_life)

		if Game.player_life <= 0:
			print("Mudando para a tela de game over.")
			get_tree().change_scene_to_file("res://Menu/game_over.tscn")
		# Remove o tiro da cena
		queue_free()			
