extends CanvasLayer

@onready var start_button = $CenterContainer/VBoxContainer/StartButton


var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()
	
	

func _on_start_button_pressed():
	if !pressed:
		pressed = true
		await LevelTransition.fade_to_black(1)
		get_tree().change_scene_to_file("res://scenes/test_world.tscn")
		LevelTransition.fade_from_black(1)
	
	

func _on_quit_button_pressed():
	get_tree().quit()



func _on_tutorial_pressed():
	if !pressed:
		pressed = true
		await LevelTransition.fade_to_black(1)
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
		LevelTransition.fade_from_black(1)
