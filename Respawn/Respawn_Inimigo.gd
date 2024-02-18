extends Node2D

const ENEMY_SCENE = preload("res://Cenas/mob_simples.tscn")

# Referência ao Timer
  # Ajuste para corresponder ao nome do nó Timer na sua cena
@onready var respawn_point = $"."
@onready var respawn_timer = $respawn_timer as Timer

func _ready():
#-----Logica do respawn-------#
	# Conecta o sinal 'timeout' do Timer ao método de respawn
		##Controla pelo time###
	print("Método _ready FORA DA ARVORE chamado") 
	$Timer.connect("timeout", Callable(self, "_on_respawn_timer_timeout"))
	$respawn_timer.start()
	# Inicia o Timer

##-----RESPAWN LOGICA----##
func _on_respawn_timer_timeout():
	var enemy = ENEMY_SCENE.instantiate()
	# Instancia um novo inimigo
	# Adiciona o inimigo instanciado à cena
	add_child(enemy)
	# Define a posição do inimigo (ajuste conforme necessário)
	enemy.global_position = get_respawn_position()
	print("Respawn Timer Timeout")
	print("Inimigo respawnou na posição: ", enemy.global_position)
	enemy.scale = Vector2(2.585, 2.806)  # Ajuste os valores conforme necessário par	a o tamanho desejado

func get_respawn_position():
	return Vector2(500, 500)
