extends Node
class_name Door

@onready var collider = $CollisionShape2D

func set_disabled(disabled: bool):
	collider.disabled = disabled

