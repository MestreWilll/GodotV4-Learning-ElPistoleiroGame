extends CharacterBody2D

signal enemy_attack
signal attack_animation_finished  # Sinal para quando a animação de ataque terminar
signal shot_delay_finished  # Sinal para quando o delay entre tiros terminar

const BULLET_ENEMY_SCENE = preload("res://Inimigos_cenario/bullet_enemy.tscn")
@onready var anim_enemy = $anim_enemy
@onready var player_detector_right = $player_detector_right
@onready var player_detector_left = $player_detector_left
@onready var ground_detector = $ground_detector
@onready var spawn_bullet_position = $spawn_bullet

var knockback_vector = Vector2()  # Vetor de knockback para empurrar o personagem quando atingido
var player_position: Vector2 = Vector2()
var speed: float = 100.0
var attack_distance: float = 200.0
var stop_distance: float = 150.0
var facing_direction: int = 1

var is_attacking: bool = false

func _ready() -> void:
	add_to_group("enemies")
	anim_enemy.play("idle")
	anim_enemy.connect("animation_finished", Callable(self, "_on_AnimationPlayer_animation_finished"))

func _physics_process(delta: float) -> void:
	var player_detected: bool = detect_player()
	
	if player_detected:
		var distance_to_player: float = global_position.distance_to(player_position)
		
		if distance_to_player > stop_distance:
			move_towards_player(delta)
			if not is_attacking:
				attack(true)
				spawn_bullet()
		elif distance_to_player <= stop_distance:
			if not is_attacking:
				attack(false)
				spawn_bullet()
	else:
		anim_enemy.play("idle")
		is_attacking = false

func detect_player() -> bool:
	player_detector_right.force_raycast_update()
	player_detector_left.force_raycast_update()

	if player_detector_right.is_colliding() and player_detector_right.get_collider().is_in_group("player"):
		spawn_bullet()
		player_position = player_detector_right.get_collider().global_position
		facing_direction = 1
		return true
	elif player_detector_left.is_colliding() and player_detector_left.get_collider().is_in_group("player"):
		player_position = player_detector_left.get_collider().global_position
		facing_direction = -1
		return true
	return false

func attack(move_while_shooting: bool) -> void:
	is_attacking = true
	anim_enemy.play("run_shoot" if move_while_shooting else "shoot")

func move_towards_player(delta: float) -> void:
	var direction: Vector2 = (player_position - global_position).normalized()
	global_position += direction * speed * delta
	
	# Espelha o sprite do inimigo com base na direção
	anim_enemy.flip_h = facing_direction == -1


func spawn_bullet() -> void:
	var bullet_instance: Node = BULLET_ENEMY_SCENE.instantiate()
	get_parent().add_child(bullet_instance)
	
	# Ajusta a posição de spawn do projétil.
	bullet_instance.global_position = spawn_bullet_position.global_position
	bullet_instance.call("set_direction", facing_direction)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "run_shoot" or anim_name == "shoot":
		emit_signal("attack_animation_finished")
		spawn_bullet()

func _on_shot_delay_finished() -> void:
	is_attacking = false
	
func _on_hurtbox_body_entered(body):
	if body and (body.is_in_group("enemies") or body.is_in_group("bullet_enemy")):
		var knockback_direction = global_position.direction_to(body.global_position)
		knockback_direction = -knockback_direction
		knockback_vector = knockback_direction * 300
		anim_enemy.modulate = Color(1, 0, 0, 1)
				
		await get_tree().create_timer(0.1).timeout
		position += knockback_vector
		
		await get_tree().create_timer(0.2).timeout
		anim_enemy.modulate = Color(1, 1, 1, 1)
		print("Tomou dano")
		# Aqui você diminui a vida do jogador
		if Game.player_life > 0:
			Game.player_life -= 1
		if Game.player_life <= 0:
			get_tree().change_scene_to_file("res://Menu/game_over.tscn")
