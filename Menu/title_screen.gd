extends Control

# Este script é responsável pela tela de título do jogo, incluindo a inicialização, processamento por frame, e ações dos botões.
# Assinado: MestreWill

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta): 
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
