const Config = preload("res://scripts/dungen/config.gd");

const X_RANGE = Config.X_RANGE
const Y_RANGE = Config.Y_RANGE
const G_ITERS = Config.G_ITERS
const ROOM_VARIANTS = Config.ROOM_VARIANTS

class RoomNode:
	var pos: Vector2
	var size: Vector2
	var vel: Vector2
	var accel: Vector2

	static func init(new_pos: Vector2, new_size: Vector2) -> RoomNode:
		var this = RoomNode
		this.pos = new_pos
		this.size = new_size
		this.vel = Vector2.ZERO
		this.accel = Vector2.ZERO
		return this

	func collides_with(other: RoomNode) -> bool:
		var box_min_x = other.pos.x - other.size.x;
		var box_max_x = other.pos.x + other.size.x;
		var box_min_y = other.pos.y - other.size.y;
		var box_max_y = other.pos.y + other.size.y;

		var me_min_x = self.pos.x - self.size.x;
		var me_max_x = self.pos.x + self.size.x;
		var me_min_y = self.pos.y - self.size.y;
		var me_max_y = self.pos.y + self.size.y;

		return me_min_x <= box_max_x && me_max_x >= box_min_x && me_min_y <= box_max_y && me_max_y >= box_min_y

func get_rooms_center_of_mass(nodes: Array[RoomNode]) -> Vector2:
	var dx = len(nodes)
	var dy = len(nodes)

	var nx = nodes.reduce(func (accum, n): return accum + n.pos.x, 0.0)
	var ny = nodes.reduce(func (accum, n): return accum + n.pos.y, 0.0)

	return Vector2(nx / dx, ny / dy)

func rooms_populate(count: int) -> Array[RoomNode]:
	var nodes = []

	# Randomly populate `nodes` with rooms from `ROOM_VARIANTS`
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
		
		var node = RoomNode.init(Vector2(x, y), Vector2(w, h));
		nodes.push_back(node)

	return nodes

func rooms_gen(nodes: Array[RoomNode]):
	var had_collisions = true

	# Big Bang - move all rooms away from each other
	while had_collisions:
		for n_idx in range(0, len(nodes)):
			var n = nodes[n_idx]
			var b = false

			for nn_idx in range(0, len(nodes)):
				var nn = nodes[nn_idx]

				if n.collides_with(nn):
					if n_idx != nn_idx:
						if n.pos == nn.pos:
							n.pos += randf_range(0.0, 0.1)
							pass

						n.vel = (n.pos - nn.pos).normalized()
						b = true
						had_collisions = true

			if b:
				n.vel += n.accel
				n.pos += n.vel
			else:
				n.vel = Vector2.ZERO
				n.accel = Vector2.ZERO

	# Gravitate rooms towards center of mass 
	for _i in range(0, G_ITERS):
		var cm = get_rooms_center_of_mass(nodes)

		for n_idx in range(0, len(nodes)):
			var n = nodes[n_idx]
			var next_pos = n.pos + (cm + n.pos).normalized()
			
			# Equivalent to `[].iter().enumerate()`
			var enumerated_nodes = []
			for nn_idx in nodes:
				enumerated_nodes.push_back([nn_idx, nodes[nn_idx]])

			if !enumerated_nodes.any(func (e): return e[0] != n_idx && e[1].collides_with(RoomNode.init(Vector2(next_pos.x, n.pos.y), n.size))):
				n.pos.x = next_pos.x

			if !enumerated_nodes.any(func (e): return e[0] != n_idx && e[1].collides_with(RoomNode.init(Vector2(n.pos.x, next_pos.y), n.size))):
				n.pos.y = next_pos.y

	# Snap each room to the grid
	for n in nodes:
		n.pos.x = round(n.pos.x)
		n.pos.y = round(n.pos.y)
		n.size.x = round(n.size.x)
		n.size.y = round(n.size.y)

func rooms_inject_room(nodes: Array[RoomNode], initial_node: RoomNode):
	var n = initial_node

	# Gravitate the room towards center of mass until it hits something
	while true:
		var x_collision = false
		var y_collision = false

		var cm = get_rooms_center_of_mass(nodes)
		var next_pos = n.pos + (cm - n.pos).normalized()

		if nodes.any(func (nn): return nn.collides_with(RoomNode.init(Vector2(next_pos.x, n.pos.y), n.size))):
			n.pos.x = next_pos.x
		else:
			x_collision = true

		if nodes.any(func (nn): return nn.collides_with(RoomNode.init(Vector2(n.pos.x, next_pos.y), n.size))):
			n.pos.y = next_pos.y
		else:
			y_collision = true

		if x_collision || y_collision:
			break

	# Snap to grid
	n.pos.x = round(n.pos.x)
	n.pos.y = round(n.pos.y)
	n.size.x = round(n.size.x)
	n.size.y = round(n.size.y)
	nodes.push_back(n)

