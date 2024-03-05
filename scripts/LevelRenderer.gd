extends TileMap

const RendererScript = preload("res://scripts/dungen/renderer.gd")
const CheckerScript = preload("res://scripts/dungen/checker.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")
const RoomsScript = preload("res://scripts/dungen/rooms.gd")

func _ready():
	var rooms: Array[RoomsScript.RoomNode]
	var doors: Array[DoorsScript.DoorNode]
	while true:
		rooms = RoomsScript.rooms_populate(6)
		RoomsScript.rooms_gen(rooms)

		var start_room = RoomsScript.RoomNode.init(Vector2(0.0, 200.0), Vector2(10.0, 10.0))
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

func _process(delta):
	pass
