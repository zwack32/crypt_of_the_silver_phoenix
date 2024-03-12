extends Node2D
class_name RoomManager

@export var room_battle_instance_scene: PackedScene
@export var player: Player

var entered_rooms: Array[Room]
var triggered_room: Room
var triggered_battle: RoomBattleInstance
var doors: Array[Door]

var nontrigger_rooms: Array[Room]

func add_non_trigger_room(room: Room):
	nontrigger_rooms.push_back(room)

func add_door(door: Door):
	doors.push_back(door)

func is_room_triggerable(room: Room) -> bool:
	return !nontrigger_rooms.any(func (r): return r.pos == room.pos)

func get_triggered_room():
	return triggered_room
	
func enter_room(room: Room):
	entered_rooms.push_back(room)
	
func exit_room():
	entered_rooms.pop_front()

	if len(entered_rooms) == 1:
		trigger(entered_rooms[0])

func trigger(room: Room):
	if !is_room_triggerable(room):
		return
	
	triggered_room = room
	triggered_battle = room_battle_instance_scene.instantiate()
	triggered_battle.room_level = 4
	triggered_battle.player = player
	triggered_battle.room_position = room.position
	triggered_battle.room_size = room.get_pixel_size()
	add_child(triggered_battle)
	
	triggered_battle.begin_battle()
	triggered_battle.connect("battle_ended", untrigger_room)

	for door in doors:
		door.call_deferred("set_disabled", false)

func untrigger_room():
	for door in doors:
		door.call_deferred("set_disabled", true)
