extends CanvasLayer

@onready var resume_btn = $menu_holder/resume_btn
@onready var android_button = $"../Android_button"
@onready var virtual_joystick = $"../Virtual Joystick"
@onready var control_contagem = $"../Control"
@onready var hud_total = $"../Imagens_controls"

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
		# Logica que esconde tudo depois de um pasuse
		android_button.visible = false
		virtual_joystick.visible = false


		get_tree().paused = true
		resume_btn.grab_focus()

func _on_resume_btn_pressed():
	get_tree().paused = false
	visible = false
		# Logica que esconde tudo depois de um pasuse (Aqui é o show)
	android_button.visible = true
	virtual_joystick.visible = true



func _on_quit_btn_pressed():
	get_tree().quit()


func _on_volta_menu_pressed():
	get_tree().change_scene_to_file("res://Menu/title_screen.tscn")
