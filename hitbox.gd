extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		# Verifique se o nó AnimatedSprite está corretamente configurado
		if owner.has_node("AnimatedSprite2D"):
			var animated_sprite = owner.get_node("AnimatedSprite2D")
			animated_sprite.play("hurt")
		else:
			print("AnimatedSprite não encontrado")
