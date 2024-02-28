extends Node

@onready var name_label = $"../Control_label_request/name_label"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("http://localhost:8080/")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if typeof(json) == TYPE_ARRAY:
			# Create an array to hold player data dictionaries
			var players_data = []
			# Iterate over each player object in the array
			for player in json:
				# Append each player's details as a dictionary to the players_data array
				players_data.append({"id": player["id"], "player_name": player["player_name"], "score": player["score"]})
			# Store the players_data array in a global variable or pass it to another function for further processing
			Game.players_data = players_data
			var player_name_label = Game.players_data[1]["player_name"]
			$"../Control_label_request/name_label".text = str(player_name_label)
		else:
			print("Error: JSON is not an array")
	else:
		print("Error:", result)

