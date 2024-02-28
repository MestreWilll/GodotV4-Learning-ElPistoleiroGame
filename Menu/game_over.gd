extends Control

@onready var time_label = $Control_label_request/time_label
@onready var score_label = $Control_label_request/score_label
@onready var coins_label = $Control_label_request/coins_label
#@onready var name_label = $Control_label_request/name_label
@onready var recorde_label = $Control_label_request/recorde_label


func _ready():
	pass
# Aqui eu chamo as var predefinidas com as mudanças para as var que são armazenadas
# Tentar passar isso pro Servidor
	time_label.text = Game.timer_counter
	score_label.text = str("%06d" % Game.score)
	coins_label.text = str("%02d" % Game.coins)
	#name_label.text = Game.player_name

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")



func _on_quit_button_pressed():
	get_tree().quit()


func _on_volta_menu_pressed():
	get_tree().change_scene_to_file("res://Menu/title_screen.tscn")
