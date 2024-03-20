extends Node2D

var dungeon_level = 1

func get_room_count() -> int:
	return dungeon_level + 6
	
func next_level():
	dungeon_level += 1
