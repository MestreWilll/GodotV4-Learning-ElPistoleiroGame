extends CharacterBody2D

# Defina as variáveis para a velocidade e o impulso do salto.
var speed = 200
var jump_impulse = -300
var velocity = Vector2.ZERO

func _physics_process(delta):
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    input_vector = input_vector.normalized()
    
    # Lida com o movimento horizontal.
    velocity.x = input_vector.x * speed
    
    # Lida com a mudança de animação para corrida ou idle.
    if input_vector.x != 0:
        $AnimationPlayer.play("run")
    else:
        $AnimationPlayer.play("idle")

    # Lida com o pulo.
    if is_on_floor() and Input.is_action_just_pressed("ui_up"):
        velocity.y = jump_impulse

    # Aplica a gravidade.
    velocity.y += 10 # Ajuste este valor conforme a necessidade do seu jogo

    # Move o personagem.
    velocity = move_and_slide(velocity, Vector2.UP)
    
    # Lida com a mudança de animação para pulo.
    if not is_on_floor():
        $AnimationPlayer.play("jump")