extends Control

# Este script é responsável pela tela de título do jogo, incluindo a inicialização, processamento por frame, e ações dos botões.
# Assinado: MestreWill
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")
	print('apertou o start')
	
func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()

func _on_opções_pressed():
	pass

