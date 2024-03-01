extends Node
class_name Room

@export var room_manager: RoomManager
@export var triggerable = true;

func _on_area_entered(area):
	if triggerable:
		room_manager.trigger_room(self)
