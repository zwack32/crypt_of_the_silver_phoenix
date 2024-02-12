extends Area2D
class_name Enemy

@export var player: Area2D
@export var speed: float = 2.0

func _ready():
	pass 

func _process(delta):
	var direction = (player.global_position - global_position).normalized()
	position += direction * speed
