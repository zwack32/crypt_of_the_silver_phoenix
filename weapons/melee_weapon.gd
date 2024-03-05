extends Area2D
class_name MeleeWeapon

@export var rot: float
@export var start_rot: float
@export var swing_speed: float
@export var player: Player

func _process(_delta):
	self.rotation_degrees += swing_speed
	rot += swing_speed
	if rot >= start_rot + 90:
		self.queue_free()

