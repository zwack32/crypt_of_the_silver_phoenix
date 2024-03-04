const RoomsScript = preload("res://scripts/dungen/rooms.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")

const RoomNode = RoomsScript.RoomNode
const DoorNode = DoorsScript.DoorNode

class CheckNode:
	var doors: Array[DoorNode]

func check(rooms: Array[RoomNode], doors: Array[DoorNode]) -> bool:
	var nodes = []
	for _r in rooms:
		nodes.push_back(CheckNode)
	for door in doors:
		rooms[door.original_room_idx].push_back(door);

	var last_count = 0;
	for idx in range(0, len(rooms)):
		var node = rooms[idx]
		var walked_rooms = [];
		walked_rooms.push_back(idx);
		if idx == 0:
			last_count = walk_room(nodes, node, walked_rooms)
		else:
			var count = walk_room(nodes, node, walked_rooms)
			if last_count != count:
				return false;

	return true

func walk_room(rooms: Array[CheckNode], room: CheckNode, walked_rooms: Array[int]) -> int:
	var room_count = 0

	for door in room.doors:
		var next_room = rooms[door.pair_room_idx]
		if !walked_rooms.has(door.pair_room_idx):
			room_count += 1
			walked_rooms.push_back(door.pair_room_idx)
			room_count += walk_room(rooms, next_room, walked_rooms)

	return room_count

