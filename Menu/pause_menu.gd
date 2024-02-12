extends CanvasLayer

@onready var resume_btn = $menu_holder/resume_btn

# Chamado quando o nó entra na árvore de cenas pela primeira vez.
func _ready():
	pass # Substitua pelo corpo da função.

# Chamado a cada frame. 'delta' é o tempo decorrido desde o frame anterior.
@warning_ignore("unused_parameter")
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		visible = true
		get_tree().paused = true
		resume_btn.grab_focus()
		

func _on_resume_btn_pressed():
	get_tree().paused = false
	visible = false


func _on_quit_btn_pressed():
	get_tree().quit()
