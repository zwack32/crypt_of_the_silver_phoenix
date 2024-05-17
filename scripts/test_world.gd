extends Node2D

@export var is_tutorial = false

@onready var standard_bgm = $standard_theme_bgm
@onready var tutorial_nodes = $TutorialNodes

func _ready():
	standard_bgm.volume_db = -50
	pass

func _process(delta):
	if standard_bgm.volume_db <= 0:
		standard_bgm.volume_db += 0.5
	pass
