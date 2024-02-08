# Supondo que este seja o script do inimigo
extends Area2D

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		if owner.has_method("play_hurt_animation"):
			owner.play_hurt_animation()  # Chama a função para tocar a animação de "hurt" e gerenciar o grupo
			print("Você matou um inimigo")
			area.queue_free()  # Remove o projétil
		else:
			print("Método play_hurt_animation não encontrado")
