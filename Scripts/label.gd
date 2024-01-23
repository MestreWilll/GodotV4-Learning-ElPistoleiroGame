extends Label

func _ready():
	# Configura o texto inicial para '0' ou o valor atual de moedas coletadas
	text = str(Game.coins_collected)

# Esta função é chamada pelo script da moeda para atualizar a contagem
func update_coins_count(new_count):
	text = str(new_count)
