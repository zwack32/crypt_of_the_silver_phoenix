extends Node
class_name Room

@onready var sprite_2d = $Sprite2D
@export var room_manager: RoomManager

func set_room_manager(new_room_manager: RoomManager):
	room_manager = new_room_manager

func get_pixel_size() -> Vector2:
	return sprite_2d.get_rect().size * 1.75
