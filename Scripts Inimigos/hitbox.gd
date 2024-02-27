# Supondo que este seja o script do inimigo
extends Area2D

var is_hurt = false

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		# Verifica se o inimigo está na animação de "hurt"
		if is_hurt:
			print("Inimigo está machucado, ignorando mais danos.")
			# Não remove o projétil, permitindo que ele continue
			return
		# Se o inimigo não está na animação de "hurt", executa a animação de dano
		if owner.has_method("play_hurt_animation"):
			is_hurt = true
			owner.play_hurt_animation()
			print("Você atingiu um inimigo")
			# Remove o projétil
			area.queue_free()
		else:
			print("Método play_hurt_animation não encontrado")

# Adicione um método para lidar com o fim da animação de "hurt"
func on_hurt_animation_finished():
	is_hurt = false
