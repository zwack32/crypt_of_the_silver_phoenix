const X_RANGE = 10
const Y_RANGE = 50
const ROOM_VARIANTS = [
	[10.0, 10.0, 4],
	[25.0, 25.0, 2],
	[20.0, 10.0, 2],
	[10.0, 30.0, 1],
]

class RoomNode:
	var pos: Vector2
	var size: Vector2
	var vel: Vector2
	var accel: Vector2

func room_populate(count: int):
	var nodes = []

	for _idx in range(0, count):
		var x = randi_range(-X_RANGE, X_RANGE)
		var y = randi_range(-Y_RANGE, Y_RANGE)
		
		var total_bias = ROOM_VARIANTS.reduce(func (accum, variant): return accum + variant[2]);
		var random_bias = randi_range(1, total_bias + 1)
		var cumulative_bias = 0
		var selected_idx = 0
		for idx in range(0, len(ROOM_VARIANTS)):
			cumulative_bias += ROOM_VARIANTS[idx][2]
			if random_bias <= cumulative_bias:
				selected_idx = idx;
				break

		var w = ROOM_VARIANTS[selected_idx][0]
		var h = ROOM_VARIANTS[selected_idx][1]
		
		var node = RoomNode;
		node.pos = Vector2(x, y)
		node.size = Vector2(w, h)
		node.vel = Vector2.ZERO
		node.accel = Vector2.ZERO
		nodes.push_back(node)

func gen(nodes: Array[RoomNode]):
	pass

