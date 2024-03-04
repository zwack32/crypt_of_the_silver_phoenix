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
		doors = DoorsScript.doors_gen(rooms)
		if CheckerScript.check(rooms, doors):
			break
		
	RendererScript.render_level(self, rooms, doors)

func _process(delta):
	pass
