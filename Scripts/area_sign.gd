extends Area2D


@onready var area_2d = $"."
@onready var sprite = $AnimatedSprite2D

const lines : Array[String] = [
	"Olá aventureiro, aqui começa o game",
	"Você está pronto?",
	"Precisamos testar",
	"vamos lá",
]

func _unhandled_input(event):
	if area_2d.get_overlapping_bodies().size() > 0:
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			sprite.hide()
			DialogManager.start_message(global_position, lines)
			print("ta passando")
		else:
			sprite.show()
	else:
		sprite.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
