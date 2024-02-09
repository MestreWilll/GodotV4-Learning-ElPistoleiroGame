extends Area2D

var coins := 1# Adiciona uma variável para verificar se a moeda já foi coletada

func _on_body_entered(_body):
		$AnimatedSprite2D.play("collect")
		#Anotação dessa linha, para não haver duplicação nos coins
		await $CollisionShape2D.call_deferred("queue_free")
		Game.coins += 1
		print(Game.coins)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "collect":
		queue_free()

