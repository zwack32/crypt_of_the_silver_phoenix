extends Node2D
class_name RoomManager

var triggered_room: Room

func get_triggered_room():
	return triggered_room
	
func trigger_room(room: Room):
	print("Room Triggered!")
	triggered_room = room
	
func untrigger_room():
	triggered_room = null
