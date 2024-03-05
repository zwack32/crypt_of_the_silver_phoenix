extends Node
class_name Room

@export var room_manager: RoomManager
#@export 

func set_room_manager(new_room_manager: RoomManager):
	room_manager = new_room_manager

func _on_area_entered(area):
	if area is PlayerArea:
		room_manager.enter_room(self)


func _on_area_exited(area):
	if area is PlayerArea:
		room_manager.exit_room()
