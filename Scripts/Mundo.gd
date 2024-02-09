extends Node2D

@onready var Player = $Player as CharacterBody2D
@onready var camera = $camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.follow_camera(camera)
	Player.player_has_died.connect(reload_game)
	Game.coins = 0
	Game.score = 0
	Game.player_life = 3
	
@warning_ignore("unused_parameter")
func _process(delta):
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
