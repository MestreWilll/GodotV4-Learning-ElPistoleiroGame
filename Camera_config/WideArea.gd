extends Area2D

@export var area_pcam: PhantomCamera2D

func _ready() -> void:
	connect("area_entered", _entered_area)
	connect("area_exited", _exited_area)

func _entered_area(area_2D: Area2D) -> void:
	if area_2D.get_parent() is CharacterBody2D:
		var new_priority = 7
		area_pcam.set_priority(new_priority)
		print("Ta colidindo")
		print("Nova prioridade definida:", new_priority)

func _exited_area(area_2D: Area2D) -> void:
	if area_2D.get_parent() is CharacterBody2D:
		area_pcam.set_priority(0)
		print("ta saindo")
