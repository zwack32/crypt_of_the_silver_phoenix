extends Node
class_name RoomBattleInstance

@export var player: Player
@export var room_level: int
@export var room_position: Vector2
@export var room_size: Vector2
@export var slime_scene: PackedScene

var waves_left: Array[BattleWave]
signal battle_ended

class BattleWave:
	var total_enemy_count: int
	var enemies_left: int

	static func init_empty() -> BattleWave:
		var this = BattleWave.new()
		this.total_enemy_count = 0
		this.enemies_left = 0
		return this

func begin_battle():
	# TODO: Make this less bad
	for i in room_level:
		var wave = BattleWave.new() 
		wave.total_enemy_count = i + 2
		wave.enemies_left = wave.total_enemy_count
		waves_left.push_front(wave)
	waves_left[0].enemies_left = 0

func _process(_delta):
	if len(waves_left) == 0:
		battle_ended.emit()
		return

	var current_wave = waves_left[0]
	if current_wave.enemies_left == 0:
		for _i in current_wave.total_enemy_count:
			var rand_position = get_random_room_position()
			var enemy = slime_scene.instantiate()
			enemy.player = player
			enemy.room_battle_instance = self
			add_child(enemy)
		waves_left.pop_front()

func pop_enemy():
	var current_wave = waves_left[0]
	current_wave.total_enemies_left -= 1

func get_random_room_position() -> Vector2:
	var x = randf_range(-room_size.x, room_size.x)
	var y = randf_range(-room_size.y, room_size.y)
	return room_position + Vector2(x, y)
