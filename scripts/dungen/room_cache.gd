extends Node

const RendererScript = preload("res://scripts/dungen/renderer.gd")
const CheckerScript = preload("res://scripts/dungen/checker.gd")
const DoorsScript = preload("res://scripts/dungen/doors.gd")
const RoomsScript = preload("res://scripts/dungen/rooms.gd")

class GenResult:
	var rooms: Array[RoomsScript.RoomNode]
	var doors: Array[DoorsScript.DoorNode]
	var start_room_idx
	var exit_room_idx
	
var thread: Thread
var request_regen: Semaphore
var gen_ready: Semaphore
var guarded_generated_rooms: GenResult
var guarded_rooms_count: int
var mutex: Mutex

var tutorial_rooms: GenResult

var guarded_should_exit: bool
var exit_mutex: Mutex

func _ready():
	exit_mutex = Mutex.new()
	mutex = Mutex.new()
	request_regen = Semaphore.new()
	request_regen.post()
	gen_ready = Semaphore.new()
	guarded_rooms_count = Progression.get_room_count(Progression.get_dungeon_level())
	thread = Thread.new()
	thread.start(_gen.bind())
	tutorial_rooms = gen_rooms(1)

static func gen_rooms(rooms_count) -> GenResult:
	var rooms: Array[RoomsScript.RoomNode]
	var doors: Array[DoorsScript.DoorNode]

	var start_room_idx
	var exit_room_idx

	while true:
		rooms = RoomsScript.rooms_populate(rooms_count)
		RoomsScript.rooms_gen(rooms)

		var start_room = RoomsScript.RoomNode.init(Vector2(0.0, 200.0), Vector2(5.0, 5.0))
		var exit_room = RoomsScript.RoomNode.init(Vector2(0.0, -200.0), Vector2(5.0, 5.0))

		exit_room_idx = len(rooms)
		RoomsScript.rooms_inject_room(rooms, exit_room)

		start_room_idx = len(rooms)
		RoomsScript.rooms_inject_room(rooms, start_room)
		RendererScript.set_origin_to_last_room(rooms)

		doors = DoorsScript.doors_gen(rooms)
		if CheckerScript.check(rooms, doors):
			break
		
	var res = GenResult.new()
	res.rooms = rooms
	res.doors = doors
	res.start_room_idx = start_room_idx
	res.exit_room_idx = exit_room_idx
	return res

func _gen():
	while true:
		request_regen.wait()
		
		exit_mutex.lock()
		if guarded_should_exit:
			return
		exit_mutex.unlock()
		
		mutex.lock()
		guarded_generated_rooms = gen_rooms(guarded_rooms_count)
		mutex.unlock()
		gen_ready.post()

func take_rooms() -> GenResult:
	gen_ready.wait()
	var result
	mutex.lock()
	result = guarded_generated_rooms
	guarded_rooms_count = Progression.get_next_room_count()
	mutex.unlock()
	request_regen.post()
	return result
	
func take_tutorial_rooms() -> GenResult:
	return tutorial_rooms

func _exit_tree():
	exit_mutex.lock()
	guarded_should_exit = true
	exit_mutex.unlock()
	request_regen.post()
	thread.wait_to_finish()
