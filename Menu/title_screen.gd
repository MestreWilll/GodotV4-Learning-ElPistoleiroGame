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
	get_tree().change_scene_to_file("res://.godot/exported/133200997/export-d5b13bfc9b0c6da6031422aa5ac56d9f-Mundo.scn")


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()