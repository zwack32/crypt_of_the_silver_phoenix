extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var player = $"../Player"

func _process(delta):
	position = get_global_mouse_position()
