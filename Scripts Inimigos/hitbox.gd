extends Area2D


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		if owner.has_node("AnimatedSprite2D"):
			var animated_sprite = owner.get_node("AnimatedSprite2D")
			animated_sprite.play("hurt")
			print("Você matou um inimigo")
			print("Acertou misaravi")  # aviso pra mim
			area.queue_free()  # Adiciona esta linha para remover o tiro
		else:
			print("AnimatedSprite não encontrado")

