extends Node
class_name Room

@onready var sprite_2d = $Sprite2D
@export var room_manager: RoomManager
#@export 

func set_room_manager(new_room_manager: RoomManager):
	room_manager = new_room_manager

func _on_area_entered(area):
	if area.owner is Player:
		room_manager.enter_room(self)


func _on_area_exited(area):
	if area.owner is Player:
		room_manager.exit_room()

func get_pixel_size() -> Vector2:
	return sprite_2d.get_rect().size * 1.75
