extends Control

# Este script é responsável pela tela de título do jogo, incluindo a inicialização, processamento por frame, e ações dos botões.
# Assinado: MestreWill


func _ready():
	$player_name.connect("text_submitted", Callable(self, "_on_LineEdit_text_submitted"))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")



func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()

func _on_opções_pressed():
	pass
	
func _on_player_name_text_changed(new_text):
	Game.set_player_name(new_text)
	
