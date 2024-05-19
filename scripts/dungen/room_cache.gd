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
var guarded_generated_rooms: GenResult
var mutex: Mutex

var guarded_should_exit: bool
var exit_mutex: Mutex

func _ready():
	exit_mutex = Mutex.new()
	mutex = Mutex.new()
	request_regen = Semaphore.new()
	request_regen.post()
	thread = Thread.new()
	thread.start(_thread_function.bind())


func _thread_function():
	while true:
		request_regen.wait()
		
		exit_mutex.lock()
		if guarded_should_exit:
			return
		exit_mutex.unlock()
		
		mutex.lock()
		var rooms: Array[RoomsScript.RoomNode]
		var doors: Array[DoorsScript.DoorNode]

		var start_room_idx
		var exit_room_idx

		while true:
			rooms = RoomsScript.rooms_populate(Progression.get_room_count())
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
		guarded_generated_rooms = GenResult.new()
		guarded_generated_rooms.rooms = rooms
		guarded_generated_rooms.doors = doors
		guarded_generated_rooms.start_room_idx = start_room_idx
		guarded_generated_rooms.exit_room_idx = exit_room_idx
		mutex.unlock()

func take_room() -> GenResult:
	var result
	mutex.lock()
	result = guarded_generated_rooms
	mutex.unlock()
	request_regen.post()
	return result

func _exit_tree():
	exit_mutex.lock()
	guarded_should_exit = true
	exit_mutex.unlock()
	request_regen.post()
	thread.wait_to_finish()
