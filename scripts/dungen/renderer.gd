const RoomsScript = preload("res://scripts/dungen/rooms.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")

const RoomNode = RoomsScript.RoomNode
const DoorNode = DoorsScript.DoorNode

static func render_level(tm: TileMap, rooms: Array[RoomNode], doors: Array[DoorNode]):
	for room in rooms:
		draw_rect(tm, room.pos, room.size, Vector2i(1, 1))
	for door in doors:
		var size: Vector2
		if door.normal == Vector2(1.0, 0.0):
			size = Vector2(1.0, 2.0)
		elif door.normal == Vector2(-1.0, 0.0):
			size = Vector2(1.0, 2.0)
		elif door.normal == Vector2(0.0, 1.0):
			size = Vector2(2.0, 1.0)
		elif door.normal == Vector2(0.0, -1.0):
			size = Vector2(2.0, 1.0)
		else:
			printerr("This really shouldn't happen. Go yell at David")


		draw_rect(tm, door.pos, size, Vector2i(1, 1))

static func set_origin_to_room(rooms: Array[RoomNode]):
	pass

static func draw_rect(tm: TileMap, pos: Vector2, size: Vector2, atlas_position: Vector2i):
	var x = int(pos.x - size.x)
	var y = int(pos.y - size.y)
	var w = int(size.x * 2)
	var h = int(size.y * 2)

	for y_idx in range(0, h):
		for x_idx in range(0, w):
			tm.set_cell(0, Vector2i(x + x_idx, y + y_idx), 0, Vector2i(3, 2))
			
	for idx in range(0, w):
		tm.set_cell(0, Vector2i(x + idx, y), 0, Vector2i(1, 0))
	for idx in range(0, w):
		tm.set_cell(0, Vector2i(x + idx, y + h - 1), 0, Vector2i(1, 7))
		
	for idx in range(0, h):
		tm.set_cell(0, Vector2i(x, y + idx), 0, Vector2i(0, 4))
	for idx in range(0, h):
		tm.set_cell(0, Vector2i(x + w - 1, y + idx), 0, Vector2i(7, 2))
	


