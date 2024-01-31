extends Area2D

var coletada = false # Adiciona uma variável para verificar se a moeda já foi coletada

func _on_body_entered(_body):
	if not coletada: # Verifica se a moeda ainda não foi coletada
		coletada = true # Marca a moeda como coletada
		$AnimatedSprite2D.play("collect")
		# Incrementa a contagem de moedas
		Game.coins_collected += 1
		# Notifica o label para atualizar
		update_coins_label()

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func update_coins_label():
	# Emite um sinal ou chama diretamente o método do Label para atualizar
	var label_path = "../../../Controls/Label"
	var label = get_node_or_null(label_path)
	if label:
		label.update_coins_count(Game.coins_collected)
		print("Você pegou uma moeda")
	else:
		print("Label não encontrado no caminho: " + label_path)
