extends Control  # Esta linha indica que este script estende a funcionalidade de um nó do tipo Control

signal time_is_up  # Define um sinal chamado 'time_is_up' que pode ser emitido para outros nós

@onready var clock_timer = $clock_timer as Timer  # Referência ao nó Timer, que controla o tempo
@onready var coins_counter = $container/StaticBody2D/coins_counter  # Referência ao contador de moedas na interface do usuário
@onready var player_life = $container/StaticBody2D3/player_life  # Referência ao indicador de vida do jogador na interface do usuário
@onready var score_counter = $container/StaticBody2D2/score_counter  # Referência ao contador de pontuação na interface do usuário
@onready var timer_counter = $container/StaticBody2D4/timer_counter  # Referência ao contador de tempo na interface do usuário

var minutes = 0  # Variável para armazenar os minutos do cronômetro
var seconds = 0  # Variável para armazenar os segundos do cronômetro
@export_range(0, 5) var default_minutes := 5  # Permite definir os minutos padrão do cronômetro através do editor
@export_range(0, 59) var default_seconds := 0  # Permite definir os segundos padrão do cronômetro através do editor

func _ready():  # Chamado quando o nó é adicionado à cena
	reset_clock_timer()  # Chama a função para resetar o cronômetro

func _process(delta):  # Chamado a cada frame
	coins_counter.text = str("%04d" % Game.coins)  # Atualiza o texto do contador de moedas
	score_counter.text = str("%06d" % Game.score)  # Atualiza o texto do contador de pontuação
	player_life.text = str("%02d" % Game.player_life)  # Atualiza o texto do indicador de vida do jogador

func _on_clock_timer_timeout():  # Chamado quando o Timer atinge zero
	if seconds == 0:
		if minutes > 0:
			minutes -= 1  # Decrementa um minuto
			seconds = 59  # Reseta os segundos para 59
		else:
			print("Emitindo sinal time_is_up")  # Imprime uma mensagem no console
			emit_signal("time_is_up")  # Emite o sinal 'time_is_up'
	else:
		seconds -= 1  # Decrementa um segundo

	update_timer_display()  # Atualiza a exibição do cronômetro na interface do usuário

func update_timer_display():  # Função para atualizar a exibição do cronômetro
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)  # Formata e exibe o tempo restante

func reset_clock_timer():  # Função para resetar o cronômetro
	minutes = default_minutes  # Define os minutos para o valor padrão
	seconds = default_seconds  # Define os segundos para o valor padrão
	update_timer_display()  # Atualiza a exibição do cronômetro
	clock_timer.start()  # Inicia o Timer
func update_player_life(life):
	player_life.text = str("%02d" % life)
	if life <= 0:
		emit_signal("time_is_up")
	##---------##
	###MESTREWILL###
	#-------------#
