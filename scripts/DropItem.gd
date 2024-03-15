extends Area2D
class_name DropItem

const WeaponManager = preload("res://scripts/WeaponManager.gd");
const MeleeWeaponType = WeaponManager.MeleeWeaponType
const TomeType = WeaponManager.TomeType

@onready var sprite_2d = $Sprite2D

enum DropHeathValues {
	HealthSmall = 0,
	HealthMedium = 1,
	HealthBig = 2,
	_Count,
}

enum DropItemType {
	Health = 0,
	Melee = 1,
	Tome = 2,
	_Count,
}

class DropItemUnion:
	var ty: DropItemType
	var data

@export var player: Player
@export var weapon_manager: WeaponManager

var is_in_range = false
var drop_item: DropItemUnion = DropItemUnion.new()

func _ready():
	var drop_type = randi_range(0, DropItemType._Count - 1)
	var data
	if drop_type == DropItemType.Health:
		data = randi_range(0, DropHeathValues._Count - 1)
	elif drop_type == DropItemType.Melee:
		data = randi_range(0, MeleeWeaponType._Count - 1)
		sprite_2d.texture = weapon_manager.get_melee_texture(data)
	elif drop_type == DropItemType.Tome:
		data = randi_range(0, TomeType._Count - 1)
		sprite_2d.texture = weapon_manager.get_tome_texture(data)
		
	drop_item.ty = drop_type
	drop_item.data = data

func _process(delta):
	if is_in_range && Input.is_action_just_pressed("pick_up"):
		if drop_item.ty == DropItemType.Health:
			if drop_item.data == DropHeathValues.HealthSmall:
				player.set_health(player.get_health() + 0.15 * player.get_player_max_hp())
			elif drop_item.data == DropHeathValues.HealthSmall:
				player.set_health(player.get_health() + 0.25 * player.get_player_max_hp())
			elif drop_item.data == DropHeathValues.HealthSmall:
				player.set_health(player.get_health() + 0.25 * player.get_player_max_hp())
		elif drop_item.ty == DropItemType.Melee:
			weapon_manager.set_melee(drop_item.data)
			print("You got a melee from item drop")
		elif drop_item.ty == DropItemType.Tome:
			weapon_manager.set_tome(drop_item.data)
			print("You got a tome from item drop")
		queue_free()

func _on_area_entered(area):
	if area.owner is Player:
		is_in_range = true
		sprite_2d.modulate.a = 0.9

func _on_area_exited(area):
	if area.owner is Player:
		is_in_range = false
		sprite_2d.modulate.a = 1.0
