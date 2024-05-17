extends Node2D

var dungeon_level = 1
var initial_enemy_count = 3
var player_health = null

func get_dungeon_level() -> int:
	return dungeon_level

func get_room_count() -> int:
	if dungeon_level == 0:
		return 1
	elif dungeon_level <= 8:
		return round((0.4 * (dungeon_level - 1)) ** 2 + 5)
	else:
		return round(log(dungeon_level) / log(2) + 24)
	
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

func set_tutorial():
	dungeon_level = 0
