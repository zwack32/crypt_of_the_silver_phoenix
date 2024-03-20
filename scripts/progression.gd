extends Node2D

var dungeon_level = 1
var initial_enemy_count = 2
var player_health = null

func get_dungeon_level() -> int:
	return dungeon_level

func get_room_count() -> int:
	if dungeon_level == 1:
		return 1
	else:
		return dungeon_level + 10
	
func get_player_health():
	return player_health
	
func set_player_health(val: int):
	player_health = val
	
func get_initial_enemy_count():
	return initial_enemy_count
	
func next_level():
	dungeon_level += 1
	initial_enemy_count += 3

func reset():
	dungeon_level = 1
	initial_enemy_count = 2
	player_health = null
