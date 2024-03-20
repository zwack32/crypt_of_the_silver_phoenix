extends Node2D

var dungeon_level = 1
var initial_enemy_count = 2

func get_room_count() -> int:
	if dungeon_level == 1:
		return 1
	else:
		return dungeon_level + 10
	
func get_initial_enemy_count():
	return initial_enemy_count
	
func next_level():
	dungeon_level += 1
	initial_enemy_count += 3
