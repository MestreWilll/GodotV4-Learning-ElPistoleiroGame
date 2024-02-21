extends Node2D  # Esta classe estende Node2D.

@onready var sprite = $AnimatedSprite2D
@onready var area_2d = $Area2D
@onready var press = $press  # Assume-se que press é um Node que pode ser mostrado ou escondido, como um Label.
@onready var spritedialog1 = $botaoDialogo_box
@onready var spritedialog2 = $botaoAdvance_message
@onready var press2 = $press2
@onready var press3 = $press3


const lines : Array[String] = [
	"Olá aventureiro, aqui começa o alpha do game",  # Primeira linha de diálogo.
	"Vamos lembrar que é apenas a base",  # Segunda linha de diálogo.
	"Precisamos testar",  # Terceira linha de diálogo.
	"vamos lá?",  # Quarta linha de diálogo.
]

func _ready():
	# Conecta os sinais de entrada e saída do corpo com as funções correspondentes usando a nova sintaxe do Godot 4.2.
	area_2d.body_entered.connect(Callable(self, "_on_Area2D_body_entered"))
	area_2d.body_exited.connect(Callable(self, "_on_Area2D_body_exited"))
	press.show()
	press2.show()
	press3.show()
	
	spritedialog1.show()  # Mostra o botão de diálogo.
	spritedialog2.show()  # Mostra o botão para avançar a mensagem.
  # Esconde o label press inicialmente.
	
func _on_Area2D_body_entered(_body):
	press.show()
	press2.show()
	press3.show()
	spritedialog1.show()  # Mostra o botão de diálogo.
	spritedialog2.show()  # Mostra o botão para avançar a mensagem.
 # Mostra o label press quando um corpo entra na área.

func _on_Area2D_body_exited(_body):
	press.hide()
	press2.hide()
	press3.hide()
	spritedialog1.hide()  # Mostra o botão de diálogo.
	spritedialog2.hide()  # Esconde o label press quando um corpo sai da área.

# Esta função é chamada quando uma entrada não tratada é detectada.
func _unhandled_input(event):
	# Verifica se há corpos sobrepostos na área 2D.
	if area_2d.get_overlapping_bodies().size() > 0:
		sprite.show()
		# Se a ação "interact" for pressionada e não houver uma mensagem ativa...
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			sprite.hide()  # Esconde o sprite.
			DialogManager.start_message(global_position, lines)  # Inicia a mensagem com as linhas definidas na posição ajustada.
			print("ta passando")  # Imprime uma mensagem no console para fins de depuração.
		else:
			sprite.show()  # Mostra o sprite.
	else:
		sprite.hide()  # Esconde o sprite.
		# Se a caixa de diálogo existir...
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()  # Libera a caixa de diálogo.
			DialogManager.is_message_active = false  # Define que uma mensagem não está ativa.
