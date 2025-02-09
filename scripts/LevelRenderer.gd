extends TileMap

const RendererScript = preload("res://scripts/dungen/renderer.gd")
const CheckerScript = preload("res://scripts/dungen/checker.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")
const RoomsScript = preload("res://scripts/dungen/rooms.gd")

@export var room_collider: PackedScene
@export var door_collider: PackedScene
@export var room_manager: RoomManager

func _ready():
	var room_res
	if Progression.get_dungeon_level() == 0:
		room_res = RoomCache.take_tutorial_rooms()
	else:
		room_res = RoomCache.take_rooms()
	var rooms: Array[RoomsScript.RoomNode] = room_res.rooms
	var doors: Array[DoorsScript.DoorNode] = room_res.doors
	var start_room_idx = room_res.start_room_idx
	var exit_room_idx = room_res.exit_room_idx
		
	RendererScript.render_level(
		self, 
		rooms, 
		doors,
		RendererScript.RoomAtlas.init(
			Vector2i(1, 1),
			Vector2i(1, 0),
			Vector2i(3, 5),
			Vector2i(0, 1),
			Vector2i(4, 4),
			Vector2i(0, 0),
			Vector2i(4, 0),
			Vector2i(0, 5),
			Vector2i(4, 5),
		)
	)

	for room_idx in range(0, len(rooms)):
		var room = rooms[room_idx]
		var new_room_collider = room_collider.instantiate()
		new_room_collider.position = room.pos * 32.0
		new_room_collider.scale = room.size * 3.2
		new_room_collider.room_manager = room_manager
		new_room_collider.original_room_idx = room_idx

		room_manager.add_room(new_room_collider)
		
		if room_idx == start_room_idx || room_idx == exit_room_idx:
			room_manager.add_non_trigger_room(new_room_collider)
		
		if room_idx == exit_room_idx:
			var next_level_scene = preload("res://scenes/next_level.tscn")
			var next_level = next_level_scene.instantiate()
			new_room_collider.add_child(next_level)

		add_child(new_room_collider)

	for door_idx in range(0, len(doors)):
		var door = doors[door_idx]
		var new_door_collider = door_collider.instantiate()
		new_door_collider.position = door.pos * 32.0
		new_door_collider.scale = door.get_size() * 0.5
		new_door_collider.scale.y *= 0.5
		new_door_collider.direction = door.normal
		new_door_collider.original_room_idx = door.original_room_idx
		new_door_collider.room_manager = room_manager
		new_door_collider.is_pair_far = abs((doors[door.pair_room_idx].pos - door.pos).length()) >= 0.8

		room_manager.add_door(new_door_collider)

		add_child(new_door_collider)
		
	room_manager.unpair_doors()
