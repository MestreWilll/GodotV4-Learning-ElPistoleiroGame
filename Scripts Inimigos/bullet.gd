extends Area2D

var bullet_speed := 950.0
var direction := 1
var hit_enemy := false  # Adiciona um sinalizador para verificar se atingiu um inimigo


func _process(delta):
		if not hit_enemy:  # Só move o tiro se não atingiu um inimigo
			position.x += bullet_speed * direction * delta

func _on_area_entered(area):
		if area.is_in_group("enemies"):
			hit_enemy = true  # Atualiza o sinalizador
		queue_free()  # Remove o tiro da cena
		
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free() # Replace with function body.
	
func set_direction(dir):
	direction = dir
	if dir < 0:
		$AnimatedSprite2D.set_flip_h(true)
	else:
		$AnimatedSprite2D.set_flip_h(false)

		
