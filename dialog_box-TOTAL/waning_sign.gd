extends Node2D  # Esta classe estende Area2D, que é uma classe base para áreas 2D.


@onready var area_2d = $"."
@onready var sprite = $AnimatedSprite2D


# Define uma constante que é uma lista de strings. Cada string é uma linha de diálogo.
const lines : Array[String] = [
	"Olá aventureiro, aqui começa o game",  # Primeira linha de diálogo.
	"Você está pronto?",  # Segunda linha de diálogo.
	"Precisamos testar",  # Terceira linha de diálogo.
	"vamos lá",  # Quarta linha de diálogo.
]

# Esta função é chamada quando uma entrada não tratada é detectada.
func _unhandled_input(event):
	# Verifica se há corpos sobrepostos na área 2D.
	if area_2d.get_overlapping_bodies().size() > 0:
		# Se a ação "interact" for pressionada e não houver uma mensagem ativa...
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			sprite.hide()  # Esconde o sprite.
			var dialog_position = global_position + Vector2(0, -50)  
			DialogManager.start_message(dialog_position, lines)  # Inicia a mensagem com as linhas definidas na posição ajustada.
			print("ta passando")  # Imprime uma mensagem no console para fins de depuração.
		else:
			sprite.show()  # Mostra o sprite.
	else:
		sprite.hide()  # Esconde o sprite.
		# Se a caixa de diálogo existir...
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()  # Libera a caixa de diálogo.
			DialogManager.is_message_active = false  # Define que uma mensagem não está ativa.
