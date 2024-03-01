extends CanvasLayer

@onready var start_button = $CenterContainer/VBoxContainer/StartButton


# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()

func _on_start_button_pressed():
	await LevelTransition.fade_to_black()
	LevelTransition.fade_from_black()
	

func _on_quit_button_pressed():
	get_tree().quit()

