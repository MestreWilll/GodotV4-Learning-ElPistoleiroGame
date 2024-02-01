extends Node2D

@onready var Player = $Player
@onready var camera = $camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.follow_camera(camera)
