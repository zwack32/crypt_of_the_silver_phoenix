extends TileMap

const RendererScript = preload("res://scripts/dungen/renderer.gd")
const CheckerScript = preload("res://scripts/dungen/checker.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")
const RoomsScript = preload("res://scripts/dungen/rooms.gd")

@export var room_collider: PackedScene
@export var door_collider: PackedScene
@export var room_manager: RoomManager

func _ready():
	var rooms: Array[RoomsScript.RoomNode]
	var doors: Array[DoorsScript.DoorNode]

	var start_room_idx

	while true:
		rooms = RoomsScript.rooms_populate(6)
		RoomsScript.rooms_gen(rooms)

		var start_room = RoomsScript.RoomNode.init(Vector2(0.0, 200.0), Vector2(10.0, 10.0))

		start_room_idx = len(rooms)
		RoomsScript.rooms_inject_room(rooms, start_room)
		RendererScript.set_origin_to_last_room(rooms)

		doors = DoorsScript.doors_gen(rooms)
		if CheckerScript.check(rooms, doors):
			break
		
	RendererScript.render_level(
		self, 
		rooms, 
		doors,
		RendererScript.RoomAtlas.init(
			Vector2i(3, 2),
			Vector2i(1, 0),
			Vector2i(1, 7),
			Vector2i(0, 4),
			Vector2i(7, 2),
			Vector2i(1, 1),
			Vector2i(1, 1),
			Vector2i(1, 1),
			Vector2i(1, 1),
		)
	)

	for room_idx in range(0, len(rooms)):
		var room = rooms[room_idx]
		var new_room_collider = room_collider.instantiate()
		new_room_collider.position = room.pos * 16.0
		new_room_collider.scale = room.size * 1.5
		new_room_collider.room_manager = room_manager

		room_manager.add_room(new_room_collider)
		
		if room_idx == start_room_idx:
			room_manager.add_non_trigger_room(new_room_collider)

		add_child(new_room_collider)

	for door_idx in range(0, len(doors)):
		var door = doors[door_idx]
		var new_door_collider = door_collider.instantiate()
		new_door_collider.position = door.pos * 16.0
		new_door_collider.scale = door.get_size() * 0.25
		new_door_collider.direction = door.normal
		new_door_collider.original_room_idx = door.original_room_idx
		new_door_collider.room_manager = room_manager

		room_manager.add_door(new_door_collider)

		add_child(new_door_collider)
		
