extends Node2D

@onready var margin_container = $MarginContainer
@onready var inf = $MarginContainer/text_inf
@onready var nine_patch_rect = $MarginContainer/NinePatchRect
@onready var area_2d = $Area2D


var player_inside = false  # Variável para verificar se o jogador está dentro da área

func _ready():
	area_2d.body_entered.connect(Callable(self, "_on_Area2D_body_entered"))
	area_2d.body_exited.connect(Callable(self, "_on_Area2D_body_exited"))
	inf.hide()  # Esconde o label inicialmente
	margin_container.hide()
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":  # Verifica se o corpo que entrou é o jogador
		player_inside = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":  # Verifica se o corpo que saiu é o jogador
		player_inside = false
		inf.hide()  # Esconde o label quando o jogador sai da área
		margin_container.hide()
func _input(event):
	if event.is_action_pressed("ui_inf") and player_inside:
		inf.text = "Informar"  # Define o texto do label para "Informar"
		inf.show()  # Mostra o label quando a tecla "O" é pressionada e o jogador está dentro da área
		margin_container.show()
		print("passou")
