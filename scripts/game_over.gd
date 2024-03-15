extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://scenes/test_world.tscn")
	LevelTransition.fade_from_black()
