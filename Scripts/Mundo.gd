extends Node2D

# Referências aos nós na cena
@onready var Player = $Player as CharacterBody2D
@onready var hud_manager_node = $Controls/Control
@onready var respawn_timer = $respawn_timer as Timer
@onready var timer = $Timer as Timer  # Referência ao novo nó Timer
@onready var mundo = $"."
@onready var camera = $Camera_Movimentos/camera

# Pré-carrega a cena do inimigo
const ENEMY_SCENE = preload("res://Cenas/mob_simples.tscn")

func _ready():
	# Configurações iniciais do jogador e HUD
	Player.follow_camera(camera)
	Player.connect("player_has_died", Callable(self, "reload_game"))
	Game.coins = 0
	Game.score = 0
	Game.player_life = 3
	hud_manager_node.connect("time_is_up", Callable(self, "handle_game_over"))
	Player.connect("game_over", Callable(self, "_on_game_over"))
#----Lógica do timer, necessario os is.connect para reconhecer na arvore de nó----#
	# Configura e inicia o primeiro timer (respawn_timer)
	if not respawn_timer.is_connected("timeout", Callable(self, "_on_respawn_timer_timeout")):
		respawn_timer.connect("timeout", Callable(self, "_on_respawn_timer_timeout"))
	respawn_timer.wait_time = 10
	respawn_timer.start()

	# Configura e inicia o novo timer (timer)
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.wait_time = 7  # Defina o tempo de espera conforme necessário
	timer.start()

func handle_game_over():
	# Lida com o fim do jogo
	print("handle_game_over chamado")
	var game_over_timer = Timer.new()
	add_child(game_over_timer)
	game_over_timer.wait_time = 0.5
	game_over_timer.one_shot = true
	game_over_timer.connect("timeout", Callable(self, "_on_game_over_timeout"))
	game_over_timer.start()

func _on_game_over_timeout():
	# Muda a cena para a tela de game over após um tempo
	get_tree().change_scene_to_file("res://Menu/game_over.tscn")

func _on_game_over():
	# Muda a cena para a tela de game over imediatamente
	get_tree().change_scene_to_file("res://Menu/game_over.tscn")
#####----LIGADO ao TIMER 1 #####----
func _on_respawn_timer_timeout():
	# Lógica para o respawn do inimigo pelo primeiro timer (respawn_timer)
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.global_position = get_respawn_position()
	enemy.scale = Vector2(2.585, 2.806)
	print("Inimigo respawnou na posição: ", enemy.global_position)
#####----LIGADO ao TIMER 2 #####----
func _on_timer_timeout():
	# Lógica para o respawn do inimigo pelo primeiro timer (respawn_timer)
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.global_position = get_respawn_position2()
	enemy.scale = Vector2(2.585, 2.806)
	print("Inimigo respawnou na posição: ", enemy.global_position)

##---Meu meio de colocar posição no respawn, temporario, até achar uma logica melhor 1 e o 2 --##
func get_respawn_position():
	# Retorna a posição de respawn para o primeiro timer (respawn_timer)
	return Vector2(500, 500)
	
func get_respawn_position2():
	return Vector2(1900, 1094)
# Coloque uma posição, que ele faz o retorno
