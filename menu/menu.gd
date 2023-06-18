extends Control

@onready var start_button: Button = $VBoxContainer/StartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.disabled = true
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("Main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_join_pressed():
	start_button.disabled = false
	Globals.isHost = false


func _on_create_button_pressed():
	start_button.disabled = false
	Globals.isHost = true
