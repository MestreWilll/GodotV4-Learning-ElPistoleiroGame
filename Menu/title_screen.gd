extends Control

# Este script é responsável pela tela de título do jogo, incluindo a inicialização, processamento por frame, e ações dos botões.
# Assinado: MestreWill


func _ready():
	$player_name.connect("text_submitted", Callable(self, "_on_LineEdit_text_submitted"))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")
	print('apertou o start')
	
func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()

func _on_opções_pressed():
	pass
	
	
func _on_player_name_text_submitted(name):
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var score = '0'
	var body = "name=" + name + "&score=" + score
	print('meu testes de input')
	$HTTPRequest.request("http://localhost:8080/register.php", headers, HTTPClient.METHOD_POST, body)
	$HTTPRequest.connect("request_completed", Callable(self, "_on_request_completed"))

func _on_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Error sending request: ", result)
	elif response_code != 200:
		print("Error in request: HTTP Response Code ", response_code)
	else:
		print("Request successful!")
