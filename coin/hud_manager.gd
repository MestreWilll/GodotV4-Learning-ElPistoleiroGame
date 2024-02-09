extends Control

@onready var coins_counter = $container/coins_comtainer/coins_counter
@onready var timer_counter = $container/timer_counter/timer_counter
@onready var life_counter = $container/life_container/life_counter
@onready var score_counter = $container/score_coumteiner/score_counter

	
func _ready():
	score_counter.text = str("%06d" % Game.score)
	coins_counter.text = str("%04d" % Game.coins)



# Esta função é chamada pelo script da moeda para atualizar a contagem
@warning_ignore("unused_parameter")
func _process(delta):
	coins_counter.text = str("%04d" % Game.coins)
	score_counter.text = str("%06d" % Game.score)



