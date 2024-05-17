extends Node2D
class_name RoomManager

@export var room_battle_instance_scene: PackedScene
@export var drop_item_scene: PackedScene
@export var indicator_border: IndicatorBorder
@export var player: Player

var entered_rooms: Array[Room]
var entered_room_areas: Array[int]
var triggered_room: Room = null
var triggered_battle: RoomBattleInstance

var room_level = 1

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

func enter_room_area(room_idx: int):
	entered_room_areas.push_back(room_idx)

func exit_room_area(room_idx: int):
	entered_room_areas.erase(room_idx)
	
func exit_room(room_idx: int):
	var a = rooms[room_idx]
	entered_rooms.erase(rooms[room_idx])
	if len(entered_rooms) == 0 && entered_room_areas.has(room_idx):
		trigger(a)

func trigger(room: Room):
	if !is_room_triggerable(room) || triggered_room != null:
		return
	
	triggered_room = room
	
	triggered_battle = room_battle_instance_scene.instantiate()
	triggered_battle.room_level = room_level
	triggered_battle.player = player
	triggered_battle.room_position = room.position * 3.0
	triggered_battle.room_size = room.get_pixel_size() * 2.0
	triggered_battle.indicator_border = indicator_border
	add_child(triggered_battle)
	
	triggered_battle.begin_battle()
	triggered_battle.connect("battle_ended", untrigger_room)

	for door in doors:
		door.call_deferred("set_disabled", false)
		
	room_level += 1

func untrigger_room():
	var item_drop = drop_item_scene.instantiate()
	item_drop.player = player
	item_drop.position = triggered_room.position * 3.0
	add_child(item_drop)
	
	add_non_trigger_room(triggered_room)
	for door in doors:
		door.call_deferred("set_disabled", true)
		
	triggered_room = null
	
func unpair_doors():
	for door in doors:
		if door.direction == Vector2.DOWN:
			door.hide()
