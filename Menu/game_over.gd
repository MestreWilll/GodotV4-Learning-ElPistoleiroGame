extends Control

@onready var time_label = $Control_label_request/time_label
@onready var score_label = $Control_label_request/score_label
@onready var coins_label = $Control_label_request/coins_label
@onready var name_label = $Control_label_request/name_label



func _ready():

	time_label.text = Game.timer_counter
	score_label.text = str("%06d" % Game.score)
	coins_label.text = str("%04d" % Game.coins)
	
	print("Meu numero de Score: ", Game.score) 
	print("Tempo de morte do jogador na tela de Game Over: ", Game.timer_counter) 
	print("Coins que foram pegos: ", Game.coins) 
		
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_volta_menu_pressed():
	get_tree().change_scene_to_file("res://Menu/title_screen.tscn")
