extends Control

@onready var ip_field: LineEdit  = $VBoxContainer/IP 

func _on_quit_button_pressed():
	get_tree().quit()


func _on_join_pressed():
	Globals.isHost = false
	Globals.hostIP = "localhost"
	get_tree().change_scene_to_file("Main.tscn")
	


func _on_create_button_pressed():
	Globals.isHost = true
	Globals.hostIP = "localhost"
	get_tree().change_scene_to_file("Main.tscn")
	


func _on_ip_text_submitted(adress):
	Globals.isHost = false
	Globals.hostIP = adress
	get_tree().change_scene_to_file("res://Main.tscn")
