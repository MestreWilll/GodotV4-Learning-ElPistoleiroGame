# Scripts/inimigos.gd
extends CharacterBody2D

var direction := -1  # Inicialmente indo para a esquerda

func _ready():
	# Verifica se o metadado "Direita" existe e se está ativo
	if has_meta("Direita") and get_meta("Direita"):
		direction = 1  # Muda a direção para a direita

# ... resto do seu script ...
