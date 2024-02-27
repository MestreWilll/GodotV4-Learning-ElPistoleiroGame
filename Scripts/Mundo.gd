extends Node2D

# Referências aos nós na cena
@onready var Player = $Player as CharacterBody2D
@onready var hud_manager_node = $Controls/Control
@onready var respawn_timer = $respawn_timer as Timer
@onready var timer = $Timer as Timer  # Referência ao novo nó Timer
@onready var mundo = $"."
@onready var camera = $Camera_Movimentos/camera
var initial_respawn_time = 10  # Tempo inicial para respawn_timer
var initial_timer_time = 8     # Tempo inicial para timer
var enemy_kill_count = 0

# Pré-carrega a cena do inimigo
const ENEMY_SCENE = preload("res://Cenas/mob_simples.tscn")

func _ready():
	# Configurações iniciais do jogador e HUD
	Player.follow_camera(camera)
	Player.connect("player_has_died", Callable(self, "reload_game"))
	Game.coins = 0
	Game.score = 0
	Game.player_life = 3
	respawn_timer.wait_time = initial_respawn_time
	timer.wait_time = initial_timer_time

	# Removido a conexão com o sinal 'time_is_up' para evitar transição para tela de Game Over
	Player.connect("game_over", Callable(self, "_on_game_over"))
	# Configura e inicia o primeiro timer (respawn_timer)
	if not respawn_timer.is_connected("timeout", Callable(self, "_on_respawn_timer_timeout")):
		respawn_timer.connect("timeout", Callable(self, "_on_respawn_timer_timeout"))

	respawn_timer.start()
	# Configura e inicia o novo timer (timer)
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	timer.start()

# Removida a função handle_game_over e suas chamadas relacionadas

# Removida a função _on_game_over_timeout

func _on_game_over():
	# Muda a cena para a tela de game over imediatamente
	get_tree().change_scene_to_file("res://Menu/game_over.tscn")

#####----LIGADO ao TIMER 1 #####----
func enemy_killed():
	# Incrementa o contador de inimigos abatidos
	enemy_kill_count += 1

	# Verifica se o contador atingiu 10
	if enemy_kill_count % 40 == 0:
		# Reseta o tempo dos timers para os valores iniciais
		initial_respawn_time = 10
		initial_timer_time = 7
	else:
		# Reduz os tempos dos timers, mas não abaixo de 1 segundo
		initial_respawn_time = max(1, initial_respawn_time - 1)
		initial_timer_time = max(1, initial_timer_time - 1)

	# Atualiza os timers com os novos tempos de espera
	respawn_timer.wait_time = initial_respawn_time
	timer.wait_time = initial_timer_time
	
func _on_respawn_timer_timeout():
	# Lógica para o respawn do inimigo pelo primeiro timer (respawn_timer)
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.global_position = get_respawn_position()
	enemy.scale = Vector2(2.585, 2.806)
	enemy_killed()
	print("Inimigo respawnou na posição: ", enemy.global_position)
	# Mostra o tempo atual do timer
	print("Tempo atual do respawn_timer: ", respawn_timer.wait_time)
	# Reinicia o timer
	respawn_timer.start()

func _on_timer_timeout():
	# Lógica para o respawn do inimigo pelo segundo timer (timer)
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.global_position = get_respawn_position2()
	enemy.scale = Vector2(2.585, 2.806)
	enemy_killed()
	print("Inimigo respawnou na posição: ", enemy.global_position)
	# Mostra o tempo atual do timer
	print("Tempo atual do timer: ", timer.wait_time)
	# Reinicia o timer
	timer.start()

##---Meu meio de colocar posição no respawn, temporario, até achar uma logica melhor 1 e o 2 --##
func get_respawn_position():
	# Retorna a posição de respawn para o primeiro timer (respawn_timer)
	return Vector2(180, 1094)
	
func get_respawn_position2():
	# Retorna a posição de respawn para o segundo timer (timer)
	return Vector2(1900, 1094)


