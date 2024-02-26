extends Control

# Sinais e referências aos nós
@onready var clock_timer = $clock_timer as Timer
@onready var player_life = $container/Moving_life/player_life
@onready var score_counter = $container/Moving_SCORE/score_counter
@onready var coins_counter = $container/Moving_Coins/coins_counter
@onready var timer_counter = $container/Moving_time/timer_counter

# Variáveis para controlar o tempo
var minutes = 0
var seconds = 0

func _ready():
	# Inicializa o cronômetro ao carregar o script
	reset_clock_timer()

func _process(text):
	# Atualiza os contadores na interface do usuário a cada frame
	coins_counter.text = str("%04d" % Game.coins)
	score_counter.text = str("%06d" % Game.score)
	player_life.text = str("%02d" % Game.player_life)

func _on_clock_timer_timeout():
	# Incrementa os segundos e, se necessário, os minutos
	seconds += 1
	if seconds >= 60:
		minutes += 1
		seconds = 0

	# Atualiza a exibição do cronômetro na interface do usuário
	update_timer_display()
	# Atualiza o tempo de morte do jogador na variável global
	Game.player_death_time = timer_counter.text

func update_timer_display():
	# Formata e exibe o tempo atual no cronômetro
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

func reset_clock_timer():
	# Reseta o cronômetro para 00:00 e inicia a contagem
	minutes = 0
	seconds = 0
	update_timer_display()
	clock_timer.start()

func update_player_life(life):
	# Atualiza a exibição da vida do jogador
	player_life.text = str("%02d" % life)
