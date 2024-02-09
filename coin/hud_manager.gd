extends Control

@onready var coins_counter = $container/coins_comtainer/coins_counter
@onready var timer_counter = $container/timer_counter/timer_counter
@onready var player_life = $container/life_container/player_life
@onready var score_counter = $container/score_coumteiner/score_counter

	
func _ready():
	coins_counter.text = str("%04d" % Game.coins)
	score_counter.text = str("%06d" % Game.score)
	player_life.text = str("%02d" % Game.player_life)



# Esta função é chamada pelo script da moeda para atualizar a contagem
@warning_ignore("unused_parameter")
func _process(delta):
	coins_counter.text = str("%04d" % Game.coins)
	score_counter.text = str("%06d" % Game.score)
	player_life.text = str("%02d" % Game.player_life)



