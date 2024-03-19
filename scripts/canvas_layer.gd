extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_from_black(new_speed_scale: float):
	animation_player.speed_scale = new_speed_scale
	animation_player.play("fade_from_black")
	await animation_player.animation_finished
	
func fade_to_black(new_speed_scale: float):
	animation_player.speed_scale = new_speed_scale
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
