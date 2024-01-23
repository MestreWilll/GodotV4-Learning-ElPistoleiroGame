extends Label

func _ready():
	# Configura o texto inicial para '0' ou o valor atual de moedas coletadas
	update_coins_count(Game.coins_collected)

# Esta função é chamada pelo script da moeda para atualizar a contagem
func update_coins_count(new_count):
	text = "Moedas: " + str(new_count)
