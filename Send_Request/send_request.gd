extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("http://192.168.1.11:8080/")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())

		# Check if the JSON is an array using 'typeof'
		if typeof(json) == TYPE_ARRAY:
			# Iterate over each player object in the array
			for player in json:
				print("Player ID:", player["id"])
				print("Nickname:", player["nickname"])
				print("Score:", player["score"])
				print("----")
		else:
			print("Error: JSON is not an array")
	else:
		print("Error:", result)
