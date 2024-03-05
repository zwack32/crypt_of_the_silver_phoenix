const RoomsScript = preload("res://scripts/dungen/rooms.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")

const RoomNode = RoomsScript.RoomNode
const DoorNode = DoorsScript.DoorNode

class RoomAtlas:
	var room_atlas: Vector2i
	var top_atlas: Vector2i
	var bottom_atlas: Vector2i
	var left_atlas: Vector2i
	var right_atlas: Vector2i
	var top_left_corner_atlas: Vector2i
	var top_right_corner_atlas: Vector2i
	var bottom_left_corner_atlas: Vector2i
	var bottom_right_corner_atlas: Vector2i

	static func init(
		new_room_atlas: Vector2i,
		new_top_atlas: Vector2i,
		new_bottom_atlas: Vector2i,
		new_left_atlas: Vector2i,
		new_right_atlas: Vector2i,
		new_top_left_corner_atlas: Vector2i,
		new_top_right_corner_atlas: Vector2i,
		new_bottom_left_corner_atlas: Vector2i,
		new_bottom_right_corner_atlas: Vector2i,
	) -> RoomAtlas:
		var this = RoomAtlas.new()
		this.room_atlas = new_room_atlas
		this.top_atlas = new_top_atlas
		this.bottom_atlas = new_bottom_atlas
		this.left_atlas = new_left_atlas
		this.right_atlas = new_right_atlas
		this.right_atlas = new_right_atlas
		this.top_left_corner_atlas = new_top_left_corner_atlas
		this.top_right_corner_atlas = new_top_right_corner_atlas
		this.bottom_left_corner_atlas = new_bottom_left_corner_atlas
		this.bottom_right_corner_atlas = new_bottom_right_corner_atlas
		return this

static func render_level(
	tm: TileMap, 
	rooms: Array[RoomNode], 
	doors: Array[DoorNode],
	room_atlas: RoomAtlas,
):
	for room in rooms:
		draw_rect(tm, room.pos, room.size, room_atlas)
		draw_rect_borders(tm, room.pos, room.size, room_atlas)
	for door in doors:
		var size = door.get_size()
		draw_rect(tm, door.pos, size, room_atlas)

static func set_origin_to_last_room(rooms: Array[RoomNode]):
	var last_room = rooms[len(rooms) - 1]
	for room in rooms:
		room.pos -= last_room.pos

static func draw_rect(
	tm: TileMap, 
	pos: Vector2, 
	size: Vector2, 
	room_atlas: RoomAtlas,
):
	var x = int(pos.x - size.x)
	var y = int(pos.y - size.y)
	var w = int(size.x * 2)
	var h = int(size.y * 2)

	for y_idx in range(0, h):
		for x_idx in range(0, w):
			tm.set_cell(0, Vector2i(x + x_idx, y + y_idx), 0, room_atlas.room_atlas)

	# TODO implement corners

static func draw_rect_borders(
	tm: TileMap, 
	pos: Vector2, 
	size: Vector2, 
	room_atlas: RoomAtlas,
):
	var x = int(pos.x - size.x)
	var y = int(pos.y - size.y)
	var w = int(size.x * 2)
	var h = int(size.y * 2)

	for idx in range(0, w):
		tm.set_cell(0, Vector2i(x + idx, y), 0, room_atlas.top_atlas)
	for idx in range(0, w):
		tm.set_cell(0, Vector2i(x + idx, y + h - 1), 0, room_atlas.bottom_atlas)
		
	for idx in range(0, h):
		tm.set_cell(0, Vector2i(x, y + idx), 0, room_atlas.left_atlas)
	for idx in range(0, h):
		tm.set_cell(0, Vector2i(x + w - 1, y + idx), 0, room_atlas.right_atlas)

	# TODO implement corners

