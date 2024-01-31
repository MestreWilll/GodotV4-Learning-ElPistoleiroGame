extends Area2D

# Supondo que você tenha uma variável global ou em um singleton para manter a contagem
# Por exemplo, um singleton chamado 'Game' com uma variável 'coins_collected'

func _on_body_entered(_body):
	$AnimatedSprite2D.play("collect")
	# Incrementa a contagem de moedas
	Game.coins_collected += 1
	# Notifica o label para atualizar
	update_coins_label()

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func update_coins_label():
	# Emite um sinal ou chama diretamente o método do Label para atualizar
	var label_path = "/root/Mundo-01/CanvasLayer/Label"
	var label = get_node_or_null(label_path)
	if label_path == "/root/Mundo-01/CanvasLayer/Label":
		print("O caminho foi encontrado com sucesso")
	if label:
		label.update_coins_count(Game.coins_collected)
		print("Você pegou uma moeda")
	else:
		print("Label não encontrado no caminho: " + label_path)
