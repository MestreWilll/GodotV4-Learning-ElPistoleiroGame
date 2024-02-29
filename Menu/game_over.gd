extends Control


@onready var time_label = $Panel/time_label
@onready var score_label = $Panel/score_label
@onready var coins_label = $Panel/coins_label
@onready var top_score = $Panel/top_score
@onready var name_label = $Panel/name_label
@onready var player_name = $Panel/player_name
var score = '0'

func _ready():
# Aqui eu chamo as var predefinidas com as mudanças para as var que são armazenadas
# Tentar passar isso pro Servidor
	time_label.text = Game.timer_counter
	score_label.text = str("%06d" % Game.score)
	coins_label.text = str("%02d" % Game.coins)
	#$Panel/score_label.text = score

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_volta_menu_pressed():
	get_tree().change_scene_to_file("res://Menu/title_screen.tscn")

	
func set_score(value):
	score = str(value)
	$Panel/score_label.text = "SCORE: " + score
	
func set_hi_score(value):
	$Panel/top_score.text = "HI-SCORE: " + str(value)
	
func _on_player_name_text_submitted(new_text):
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var body = "name=" + new_text + "&score=" + score
	$HTTPRequest.request("http://localhost:8080/register.php", headers, HTTPClient.METHOD_POST, body)

	
func _on_http_request_request_completed(result, response_code, headers, body):
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")
