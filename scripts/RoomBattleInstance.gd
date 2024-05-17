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
	total_waves = roundi(log(room_level) / log(2) + 1)

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

		current_wave_enemy_count = clamp(roundi(current_wave + Progression.get_initial_enemy_count()), 1, 15)
		for _i in range(current_wave_enemy_count):
			var rand_position = get_random_room_position()
			
			var enemy_type = randi_range(0, 4)
			
			var enemy
			if enemy_type == 0:
				enemy = slime_scene.instantiate()
			elif enemy_type == 1:
				enemy = bat_scene.instantiate()
			elif enemy_type == 2:
				enemy = mage_scene.instantiate()
			elif enemy_type == 3:
				enemy = ogre_scene.instantiate()
			elif enemy_type == 4:
				enemy = goblin_scene.instantiate()

			enemy.player = player
			enemy.position = rand_position
			enemy.room_battle_instance = self
			enemy.indicator_border = indicator_border
			enemy.room_level = room_level
			get_parent().add_child(enemy)

		current_wave += 1;

func get_random_room_position() -> Vector2:
	var x = randf_range(-room_size.x, room_size.x)
	var y = randf_range(-room_size.y, room_size.y)
	return room_position + Vector2(x, y)
