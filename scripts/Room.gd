extends Node
class_name Room

@onready var sprite_2d = $Sprite2D
@export var room_manager: RoomManager
@export var original_room_idx: int

func set_room_manager(new_room_manager: RoomManager):
	room_manager = new_room_manager

func get_pixel_size() -> Vector2:
	return sprite_2d.get_rect().size * 0.001

func _on_area_entered(area):
	room_manager.enter_room_area(original_room_idx)

func _on_area_exited(area):
	room_manager.exit_room_area(original_room_idx)
