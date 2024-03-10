extends Area2D

var is_hurt = false

func _on_area_entered(body):
	if body.is_in_group("enemies"):
		# Verifica se o inimigo está na animação de "hurt"
		if is_hurt:
			print("Tomando dano no nó hitbox.")
			# Não remove o projétil, permitindo que ele continue
			return
		# Se o inimigo não está na animação de "hurt", executa a animação de dano
		if owner.has_method("play_hurt_animation"):
			is_hurt = true
			owner.play_hurt_animation()
			print("Você atingiu um inimigo no Nó hitbox")
			# Remove o projétil
			body.queue_free()
		if owner.has_method("_on_sprite_animation_finished"):
			owner._on_sprite_animation_finished()
			await owner._on_sprite_animation_finished()
			if owner.has_method("detonar_inimigo"):
				owner.detonar_inimigo()
				print("detono inimigo = Forçar uma forma dele sumir do nó como se tivesse matado")


# Adicione um método para lidar com o fim da animação de "hurt"
func on_hurt_animation_finished():
	is_hurt = false
