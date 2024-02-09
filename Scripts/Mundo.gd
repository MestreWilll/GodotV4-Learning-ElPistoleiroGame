extends Node2D

@onready var Player = $Player
@onready var camera = $camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.follow_camera(camera)

@warning_ignore("unused_parameter")
func _process(delta):
	pass


func _on_timer_timeout():
	pass # Replace with function body.


func _on_timer_ready():
	pass # Replace with function body.
