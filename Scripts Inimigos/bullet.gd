extends Area2D

var bullet_speed := 950.0
var direction := 1
var hit_enemy := false  # Adiciona um sinalizador para verificar se atingiu um inimigo


func _process(delta):
		if not hit_enemy:  # Só move o tiro se não atingiu um inimigo
			position.x += bullet_speed * direction * delta

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		# Verifica se o inimigo está na animação de "hurt"
		if area.owner.has_method("is_in_hurt_animation") and area.owner.is_in_hurt_animation():
			# O inimigo está na animação de "hurt", então o projétil ignora e continua
			print("Está acertando o hurt")
			return
		# Se o inimigo não está na animação de "hurt", o projétil é removido
		print("Não está acertando o hurt")
		queue_free()
		
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free() # Replace with function body.
	
func set_direction(dir):
	direction = dir
	if dir < 0:
		$AnimatedSprite2D.set_flip_h(true)
	else:
		$AnimatedSprite2D.set_flip_h(false)

		
