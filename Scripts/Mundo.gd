extends Node2D

@onready var Player := $Player as CharacterBody2D
@onready var camera := $camera as Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	Player.follow_camera(camera)
