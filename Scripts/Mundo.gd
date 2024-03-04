extends Node2D

# Referências aos nós na cena
@onready var Player = $Player as CharacterBody2D
@onready var hud_manager_node = $Controls/Control
@onready var respawn_timer = $respawn_timer as Timer
@onready var timer = $Timer as Timer
@onready var mundo = $"."
@onready var camera = $Camera_Movimentos/camera
@onready var timer2 = $Timer2
@onready var timer3 = $Timer3


var initial_respawn_time = 15
var initial_timer_time = 12
var initial_timer2_time = 14
var initial_timer3_time = 12
var enemy_kill_count = 0
var hi_score = 0


# Pré-carrega a cena do inimigo
const ENEMY_SCENE = preload("res://Cenas/mob_simples.tscn")

func _ready():
	Player.follow_camera(camera)
	Player.connect("player_has_died", Callable(self, "reload_game"))
	set_up_timers()

func set_up_timers():
	respawn_timer.wait_time = initial_respawn_time
	timer.wait_time = initial_timer_time
	timer2.wait_time = initial_timer2_time
	timer3.wait_time = initial_timer3_time
	respawn_timer.start()
	timer.start()
	timer2.start()
	timer3.start()

func get_respawn_position():
	return Vector2(180, 1094)

func get_respawn_position2():
	return Vector2(1900, 1094)

func get_respawn_position3():
	return Vector2(500, 500)

func get_respawn_position4():
	return Vector2(1300, 500)

func enemy_killed():
	enemy_kill_count += 1
	if enemy_kill_count % 5 == 0:
		reset_timer_values()
	else:
		decrement_timer_values()

func reset_timer_values():
	initial_respawn_time = 10
	initial_timer_time = 7
	initial_timer2_time = 7
	initial_timer3_time = 10
	update_timers()

func decrement_timer_values():
	initial_respawn_time = max(1, initial_respawn_time - 1)
	initial_timer_time = max(1, initial_timer_time - 1)
	initial_timer2_time = max(1, initial_timer2_time - 1)
	initial_timer3_time = max(1, initial_timer3_time - 1)
	update_timers()

func update_timers():
	respawn_timer.wait_time = initial_respawn_time
	timer.wait_time = initial_timer_time
	timer2.wait_time = initial_timer2_time
	timer3.wait_time = initial_timer3_time
	
func _on_player_killed():
	get_tree().change_scene("res://Menu/game_over.tscn")
