extends Node
class_name RoomBattleInstance

@export var player: Player
@export var indicator_border: IndicatorBorder
@export var room_level: int
@export var room_position: Vector2
@export var room_size: Vector2
@export var slime_scene: PackedScene
@export var bat_scene: PackedScene
@export var mage_scene: PackedScene
@export var ogre_scene: PackedScene
@export var goblin_scene: PackedScene

var current_wave = 0
var current_wave_enemy_count = 0
var total_waves

signal battle_ended

func begin_battle():
	total_waves = roundi(0.25 * room_level)

	# Prepare to call the pop_enemy function
	current_wave -= 1
	current_wave_enemy_count += 1
	pop_enemy()

func pop_enemy():
	current_wave_enemy_count -= 1
	if current_wave_enemy_count == 0:
		if current_wave == total_waves:
			battle_ended.emit()
			queue_free()
			return

		var spawn_value = roundi(6 * log(current_wave + Progression.get_initial_enemy_count() + 1) + 3)
		current_wave_enemy_count = 0
		while spawn_value > 0:
			var rand_position = get_random_room_position()
			
			var enemy_type = randi_range(0, 4)
			
			var enemy = null
			if enemy_type == 0:
				enemy = slime_scene.instantiate()
				spawn_value -= 1
			elif enemy_type == 1 && Progression.get_dungeon_level() >= 1:
				enemy = bat_scene.instantiate()
				spawn_value -= 1
			elif enemy_type == 2 && Progression.get_dungeon_level() >= 2:
				enemy = mage_scene.instantiate()
				spawn_value -= 3
			elif enemy_type == 3 && Progression.get_dungeon_level() >= 2:
				enemy = ogre_scene.instantiate()
				spawn_value -= 4
			elif enemy_type == 4:
				enemy = goblin_scene.instantiate()
				spawn_value -= 2
				
			if !enemy:
				continue
				
			enemy.player = player
			enemy.position = rand_position
			enemy.room_battle_instance = self
			enemy.indicator_border = indicator_border
			enemy.room_level = room_level
			current_wave_enemy_count += 1
			get_parent().add_child(enemy)
		current_wave += 1;

func get_random_room_position() -> Vector2:
	var x = randf_range(-room_size.x * 1.25, room_size.x * 1.25)
	var y = randf_range(-room_size.y * 1.25, room_size.y * 1.25)
	return room_position + Vector2(x, y)
