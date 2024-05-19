extends CanvasLayer

@onready var start_button = $CenterContainer/HBoxContainer/StartButton
@onready var animated_title = $AnimatedTitle
@onready var title_theme = $TitleTheme

var world_scene = preload("res://scenes/test_world.tscn")
var tutorial_scene = preload("res://scenes/tutorial_world.tscn")

var pressed = false
var music_fade = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_title.play()
	start_button.grab_focus()
	
	

func _on_start_button_pressed():
	if !pressed:
		music_fade = true
		pressed = true
		await LevelTransition.fade_to_black(1)
		get_tree().change_scene_to_packed(world_scene)
		LevelTransition.fade_from_black(1)
	
	

func _on_quit_button_pressed():
	get_tree().quit()

func _process(delta):
	if music_fade:
		title_theme.volume_db -= 0.5


func _on_tutorial_pressed():
	if !pressed:
		Progression.set_tutorial()
		pressed = true
		await LevelTransition.fade_to_black(1)
		get_tree().change_scene_to_packed(tutorial_scene)
		LevelTransition.fade_from_black(1)
