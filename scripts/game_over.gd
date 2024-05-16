extends CanvasLayer
@onready var restart_button = $RestartButton
var twice = false
@onready var death_theme = $DeathTheme
var fade_out = false
# Called when the node enters the scene tree for the first time.
func _ready():
	music_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_out and death_theme.volume_db >= -200:
		death_theme.volume_db -= 0.05
		print(death_theme.volume_db)
		#await get_tree().create_timer(0.1).timeout
	pass
	

func _on_restart_button_pressed():
	if twice:
		return
	twice = true
	Progression.reset()
	WeaponManager.reset()
	await LevelTransition.fade_to_black(1)
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	await LevelTransition.fade_from_black(1)
	
func music_ready():
	await get_tree().create_timer(4).timeout
	fade_out = true
