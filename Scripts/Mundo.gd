extends Node2D

@onready var Player = $Player as CharacterBody2D  # Referência ao jogador na cena
# O caminho para o nó HUDManager dentro da árvore de cenas
@onready var hud_manager_node = $Controls/Control  # Referência ao gerenciador de HUD
@onready var camera = $camera  # Referência à câmera na cena
@onready var respawn_timer = $Timer

const ENEMY_SCENE = preload("res://Cenas/mob_simples.tscn")

var respawn_positions = [Vector2(100, 100), Vector2(200, 200), Vector2(300, 300)]  # Lista de posições

func _ready():
	print_tree()
	Player.follow_camera(camera)  # Faz o jogador seguir a câmera
	Player.connect("player_has_died", Callable(self, "reload_game"))  # Conecta o sinal de morte do jogador ao método de recarregar o jogo
	Game.coins = 0  # Inicializa as moedas do jogo
	Game.score = 0  # Inicializa a pontuação do jogo
	Game.player_life = 3  # Inicializa as vidas do jogador
	print(get_tree().get_root().get_path_to(self))

	# Conecte o sinal 'time_is_up' do hud_manager ao método 'handle_game_over' deste script
	hud_manager_node.connect("time_is_up", Callable(self, "handle_game_over"))  # Conecta o sinal de tempo esgotado ao método de game over
	Player.connect("game_over", Callable(self, "_on_game_over"))
#-----Logica do respawn-------#
	# Conecta o sinal 'timeout' do Timer ao método de respawn
	$Timer.connect("timeout", Callable(self, "_on_respawn_timer_timeout"))
	# Inicia o Timer
	$Timer.start()
	
func handle_game_over():
	print("handle_game_over chamado")  # Imprime uma mensagem indicando que o game over foi chamado
	var timer = Timer.new()  # Cria um novo timer
	add_child(timer)  # Adiciona o timer como filho do nó atual
	timer.wait_time = 0.5  # Atraso de meio segundo antes de executar a ação
	timer.one_shot = true  # Configura o timer para executar apenas uma vez
	timer.connect("timeout", Callable(self, "_on_game_over_timeout"))  # Conecta o sinal de timeout do timer ao método de timeout do game over
	timer.start()  # Inicia o timer
	

func _on_game_over_timeout():
	get_tree().change_scene_to_file("res://Menu/game_over.tscn")  # Muda a cena para a cena de game over
	
func _on_game_over():
	get_tree().change_scene_to_file("res://Menu/game_over.tscn")  # Muda a cena para a cena de game over

##-----RESPAWN LOGICA----##
func _on_respawn_timer_timeout():
	# Instancia um novo inimigo
	var enemy = ENEMY_SCENE.instantiate()
	# Adiciona o inimigo instanciado à cena
	add_child(enemy)
	# Define a posição do inimigo (ajuste conforme necessário)
	enemy.global_position = get_respawn_position()
	enemy.scale = Vector2(2.585, 2.806)  # Ajuste os valores conforme necessário par	a o tamanho desejado

func get_respawn_position():
	return respawn_positions[randi() % respawn_positions.size()]

