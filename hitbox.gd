extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		# Verifique se o nó AnimatedSprite está corretamente configurado
		if owner.has_node("AnimatedSprite2D"):
			var animated_sprite = owner.get_node("AnimatedSprite2D")
			body.velocity.y = body.JUMP_VELOCITY
			animated_sprite.play("hurt")
			print("Você matou um inimigo") # aviso pra mim
		else:
			print("AnimatedSprite não encontrado")
