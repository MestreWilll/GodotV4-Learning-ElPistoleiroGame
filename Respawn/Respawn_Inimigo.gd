extends Node2D

const ENEMY_SCENE = preload("res://Cenas/mob_simples.tscn")

# Referência ao Timer
  # Ajuste para corresponder ao nome do nó Timer na sua cena
@onready var respawn_timer = $respawn_timer as Timer

func _ready():
	# Conecta o sinal 'timeout' do Timer ao método de respawn
	$Timer.connect("timeout", Callable(self, "_on_respawn_timer_timeout"))
	# Inicia o Timer
	$Timer.start()
	print("Timer started")  # Esta mensagem deve aparecer no console quando o jogo começa

func _on_respawn_timer_timeout():
	print("Respawning enemy")  # Esta mensagem deve aparecer no console quando o Timer atinge o tempo limite
	# Instancia um novo inimigo
	var enemy = ENEMY_SCENE.instantiate()
	# Adiciona o inimigo instanciado à cena
	add_child(enemy)
	# Define a posição do inimigo (ajuste conforme necessário)
	enemy.global_position = get_respawn_position()

func get_respawn_position():
	# Retorna uma posição para o respawn do inimigo
	# Aqui você pode definir uma lógica para a posição de respawn, como uma posição aleatória ou fixa
	return Vector2(100, 100)  # Exemplo de posição fixa
