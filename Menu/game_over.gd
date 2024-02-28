extends Control


@onready var time_label = $label_Top_Player/time_label
@onready var score_label = $label_Top_Player/score_label
@onready var coins_label = $label_Top_Player/coins_label
@onready var recorde_label = $label_Top_Player/recorde_label
#@onready var name_label = $label_Top_Player/name_label

@onready var register_label_only = $label_Register/Register_label_only
@onready var name_label_register = $label_Register/name_label_register


func _ready():
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


func _on_name_label_register_text_submitted(new_text):
	pass # Replace with function body.
