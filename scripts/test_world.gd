extends Node2D

@export var is_tutorial = false

@onready var bgm = $BGM
@onready var tutorial_nodes = $TutorialNodes

func _ready():
	bgm.play()
	
	if is_tutorial:
		pass
		# TODO work on tutorial UI
		# tutorial_nodes.show()
