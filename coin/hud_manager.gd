extends Control



@onready var clock_timer = $clock_timer as Timer
@onready var coins_counter = $container/coins_comtainer/StaticBody2D/coins_counter
@onready var timer_counter = $container/timer_counter/StaticBody2D/timer_counter
@onready var score_counter = $container/score_coumteiner/StaticBody2D/score_counter
@onready var player_life = $container/life_container/StaticBody2D/player_life

var minutes = 0
var seconds = 0
@export_range(0, 5) var default_minutes := 1
@export_range(0, 59) var default_seconds := 0


func _ready():
	coins_counter.text = str("%04d" % Game.coins)
	score_counter.text = str("%06d" % Game.score)
	player_life.text = str("%02d" % Game.player_life)
	timer_counter.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()

signal time_is_up()

# Esta função é chamada pelo script da moeda para atualizar a contagem
@warning_ignore("unused_parameter")
func _process(delta):
	coins_counter.text = str("%04d" % Game.coins)
	score_counter.text = str("%06d" % Game.score)
	player_life.text = str("%02d" % Game.player_life)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")

func _on_clock_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60 
	seconds -= 1
	
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
	
func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
	
