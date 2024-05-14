extends Node2D

@export var is_tutorial = false

@onready var standard_bgm = $standard_theme_bgm
@onready var tutorial_nodes = $TutorialNodes

func _ready():
	standard_bgm.play()
