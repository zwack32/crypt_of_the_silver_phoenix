extends Node2D


@onready var bgm = $BGM

func _ready():
	bgm.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
