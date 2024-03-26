extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var player = $"../Player"

func _process(delta):
	pass
	#position = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * player.local_position
		#position = get_viewport().get_mouse_position()+player.position
	#position -= get_viewport().size/2.0
