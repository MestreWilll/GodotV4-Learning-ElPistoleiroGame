extends Control

# Este script é responsável pela tela de título do jogo, incluindo a inicialização, processamento por frame, e ações dos botões.
# Assinado: MestreWill


func _ready():
	$player_name.connect("text_submitted", Callable(self, "_on_LineEdit_text_submitted"))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")
	if $HTTPRequest:
		var json = JSON.stringify('starting game')
		var headers = ["Content-Type: application/json"]
		$HTTPRequest.request("http://localhost:8080/register.php", headers, HTTPClient.METHOD_POST, json)
	else:
		print("HTTPRequest node is not available.")


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()

func _on_opções_pressed():
	pass
	
	
func _on_player_name_text_submitted(new_text):
	var json = JSON.stringify(new_text)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("localhost:8080/register.php", headers, HTTPClient.METHOD_POST, json)
