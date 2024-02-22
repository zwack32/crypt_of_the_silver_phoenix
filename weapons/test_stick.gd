extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
var player: Player

func _ready():
	pass

func _process(delta):
	pass

func _on_area_entered(area):
	print("area")
