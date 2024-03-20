extends Node2D
class_name RoomManager

@export var room_battle_instance_scene: PackedScene
@export var drop_item_scene: PackedScene
@export var weapon_manager: WeaponManager
@export var player: Player

var entered_rooms: Array[Room]
var triggered_room: Room
var triggered_battle: RoomBattleInstance

var room_level = 2

# It can be assumed that these arrays can be indexed with orginal room idx
var doors: Array[Door]
var rooms: Array[Room]

var nontrigger_rooms: Array[Room]

func add_non_trigger_room(room: Room):
	nontrigger_rooms.push_back(room)

func add_door(door: Door):
	doors.push_back(door)
	
func add_room(room: Room):
	rooms.push_back(room)

func is_room_triggerable(room: Room) -> bool:
	return !nontrigger_rooms.any(func (r): return r == room)

func get_triggered_room():
	return triggered_room
	
func enter_room(room_idx: int):
	entered_rooms.push_back(rooms[room_idx])
	
func exit_room(room_idx: int):
	var a = rooms[room_idx]
	entered_rooms.erase(rooms[room_idx])
	if len(entered_rooms) == 0:
		trigger(a)

func trigger(room: Room):
	if !is_room_triggerable(room):
		return
	
	triggered_room = room
	
	triggered_battle = room_battle_instance_scene.instantiate()
	triggered_battle.room_level = room_level
	triggered_battle.player = player
	triggered_battle.room_position = room.position * 3.0
	triggered_battle.room_size = room.get_pixel_size() * 1.75
	add_child(triggered_battle)
	
	triggered_battle.begin_battle()
	triggered_battle.connect("battle_ended", untrigger_room)

	for door in doors:
		door.call_deferred("set_disabled", false)
		
	room_level += 1

func untrigger_room():
	var item_drop = drop_item_scene.instantiate()
	item_drop.weapon_manager = weapon_manager
	item_drop.player = player
	item_drop.position = triggered_room.position * 3.0
	add_child(item_drop)
	
	add_non_trigger_room(triggered_room)
	for door in doors:
		door.call_deferred("set_disabled", true)
	
