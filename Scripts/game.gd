extends Node

# This variable keeps track of the number of coins collected
var coins_collected = 0

# Function to increment the count of coins
func add_coin():
	coins_collected += 1
	# Here you can emit a signal or call a function to update the UI
