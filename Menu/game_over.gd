extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://.godot/exported/133200997/export-d5b13bfc9b0c6da6031422aa5ac56d9f-Mundo.scn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_volta_menu_pressed():
	get_tree().change_scene_to_file("res://.godot/exported/133200997/export-3c0ae5175927600a5da40564799297aa-title_screen.scn")
