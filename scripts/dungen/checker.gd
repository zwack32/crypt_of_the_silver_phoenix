const RoomsScript = preload("res://scripts/dungen/rooms.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")

const RoomNode = RoomsScript.RoomNode
const DoorNode = DoorsScript.DoorNode

class CheckNode:
	var doors: Array[DoorNode]
	
	static func init() -> CheckNode:
		var this = CheckNode.new()
		return this

static func check(rooms: Array[RoomNode], doors: Array[DoorNode]) -> bool:
	var nodes: Array[CheckNode] = []
	for _r in rooms:
		nodes.push_back(CheckNode.init())
	for door in doors:
		nodes[door.original_room_idx].doors.push_back(door);

	var last_count = 0;
	for idx in range(0, len(nodes)):
		var node: CheckNode = nodes[idx]
		var walked_rooms: Array[int] = [];
		walked_rooms.push_back(idx);
		if idx == 0:
			last_count = walk_room(nodes, node, walked_rooms)
		else:
			var count = walk_room(nodes, node, walked_rooms)
			if last_count != count:
				return false;

	return true

static func walk_room(rooms: Array[CheckNode], room: CheckNode, walked_rooms: Array[int]) -> int:
	var room_count = 0
	
	for door in room.doors:
		var next_room = rooms[door.pair_room_idx]
		if !walked_rooms.has(door.pair_room_idx):
			room_count += 1
			walked_rooms.push_back(door.pair_room_idx)
			room_count += walk_room(rooms, next_room, walked_rooms)

	return room_count

