const Config = preload("res://scripts/dungen/config.gd");
const RoomsScript = preload("res://scripts/dungen/rooms.gd")

const RoomNode = RoomsScript.RoomNode

const DOOR_NEIGHBOR_SAMPLES = Config.DOOR_NEIGHBOR_SAMPLES
const DOOR_PARALLEL_DISTANCE_THRESHOLD = Config.DOOR_PARALLEL_DISTANCE_THRESHOLD
const DOOR_BORDER_ACCEPT_PROPORTION = Config.DOOR_BORDER_ACCEPT_PROPORTION

class DoorGenNode:
	var pos: Vector2
	var normal: Vector2
	var perpendicular_size: float
	var original_room_idx: int
	
	static func init(
		new_pos: Vector2, 
		new_normal: Vector2, 
		new_perpendicular_size: float, 
		new_original_room_idx: int
	) -> DoorGenNode:
		var node = DoorGenNode.new()
		node.pos = new_pos
		node.normal = new_normal
		node.perpendicular_size = new_perpendicular_size
		node.original_room_idx = new_original_room_idx
		return node

class DoorNode:
	var pos: Vector2
	var normal: Vector2
	var original_room_idx: int
	var pair_room_idx: int

	static func init(
		new_pos: Vector2, 
		new_normal: Vector2, 
		new_original_room_idx: int,
		new_pair_room_idx: int
	) -> DoorNode:
		var node = DoorNode.new()
		node.pos = new_pos
		node.normal = new_normal
		node.original_room_idx = new_original_room_idx
		node.pair_room_idx = new_pair_room_idx
		return node

	func get_size() -> Vector2:
		var size: Vector2
		if self.normal == Vector2(1.0, 0.0):
			size = Vector2(1.0, 1.0)
		elif self.normal == Vector2(-1.0, 0.0):
			size = Vector2(1.0, 1.0)
		elif self.normal == Vector2(0.0, 1.0):
			size = Vector2(1.0, 1.0)
		elif self.normal == Vector2(0.0, -1.0):
			size = Vector2(1.0, 1.0)
		else:
			printerr("This really shouldn't happen. Go yell at David")
		return size

static func doors_gen(rooms: Array[RoomNode]) -> Array[DoorNode]:
	var nodes = []
	for original_room_idx in range(0, len(rooms)):
		var room = rooms[original_room_idx]
		var left = room.pos - Vector2(room.size.x, 0.0);
		var right = room.pos + Vector2(room.size.x, 0.0);
		var up = room.pos + Vector2(0.0, room.size.y);
		var down = room.pos - Vector2(0.0, room.size.y);
		nodes.push_back(DoorGenNode.init(
			left, 
			Vector2(-1.0, 0.0), 
			room.size.y, 
			original_room_idx
		))
		nodes.push_back(DoorGenNode.init(
			right, 
			Vector2(1.0, 0.0), 
			room.size.y, 
			original_room_idx
		))
		nodes.push_back(DoorGenNode.init(
			up, 
			Vector2(0.0, 1.0), 
			room.size.x, 
			original_room_idx
		))
		nodes.push_back(DoorGenNode.init(
			down, 
			Vector2(0.0, -1.0), 
			room.size.x, 
			original_room_idx
		))

	var doors: Array[DoorNode] = []

	for n in nodes:
		var my_side_nodes = nodes
		my_side_nodes = my_side_nodes.map(func (nn): return [nn.pos - n.pos, nn])
		my_side_nodes = my_side_nodes.filter(func (i): 
			var me_to_them = i[0]
			var nn = i[1]
			return (-n.normal == nn.normal && me_to_them.normalized().dot(n.normal) >= 0.0)
		)
		my_side_nodes.sort_custom(func (a, b): return a[0].length() < b[0].length())

		var candidates = my_side_nodes
		candidates = candidates.slice(0, DOOR_NEIGHBOR_SAMPLES)
		candidates = candidates.filter(func (i):
			var me_to_them = i[0]
			var l = abs(me_to_them.x) if abs(n.normal.x) > 0.0 else abs(me_to_them.y)
			return l <= DOOR_PARALLEL_DISTANCE_THRESHOLD
		)

		for i in candidates:
			var nn = i[1]
			var use_x = abs(n.normal.x) > 0.0
			var n_pos
			var nn_pos
			if use_x:
				n_pos = n.pos.y
				nn_pos = nn.pos.y
			else:
				n_pos = n.pos.x
				nn_pos = nn.pos.x

			var them_left = nn_pos - nn.perpendicular_size * DOOR_BORDER_ACCEPT_PROPORTION
			var my_left = n_pos - n.perpendicular_size * DOOR_BORDER_ACCEPT_PROPORTION

			var them_right = nn_pos + nn.perpendicular_size * DOOR_BORDER_ACCEPT_PROPORTION
			var my_right = n_pos + n.perpendicular_size * DOOR_BORDER_ACCEPT_PROPORTION

			var left = max(my_left, them_left)
			var right = min(my_right, them_right)
			var midpoint = (left + right) / 2.0

			if my_left <= them_right && my_right >= them_left:
				var pos = Vector2(n.pos.x, midpoint) if use_x else Vector2(midpoint, n.pos.y)
				doors.push_back(DoorNode.init(pos, n.normal, n.original_room_idx, nn.original_room_idx))

	for door in doors:
		door.pos.x = round(door.pos.x)
		door.pos.y = round(door.pos.y)


	return doors

