extends Area2D
class_name DropItem

const WeaponManager = preload("res://scripts/WeaponManager.gd");
const MeleeWeaponType = WeaponManager.MeleeWeaponType
const TomeType = WeaponManager.TomeType

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

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

var is_in_range = false
var drop_item: DropItemUnion = DropItemUnion.new()

func _ready():
	var drop_type = randi_range(0, DropItemType._Count - 1)
	var data
	if drop_type == DropItemType.Health:
		data = randi_range(0, DropHeathValues._Count - 1)
		if data == DropHeathValues.HealthSmall:
			sprite_2d.texture = load("res://art/small_heart.png")
		if data == DropHeathValues.HealthMedium:
			sprite_2d.texture = load("res://art/med_heart.png")
		if data == DropHeathValues.HealthBig:
			sprite_2d.texture = load("res://art/large_heart.png")
	elif drop_type == DropItemType.Melee:
		data = randi_range(0, MeleeWeaponType._Count - 1)
		sprite_2d.texture = WeaponManager.get_melee_texture(data)
	elif drop_type == DropItemType.Tome:
		data = randi_range(0, TomeType._Count - 1)
		sprite_2d.texture = WeaponManager.get_tome_texture(data)
		
	drop_item.ty = drop_type
	drop_item.data = data

func _process(delta):
	if is_in_range && Input.is_action_just_pressed("pick_up"):
		if drop_item.ty == DropItemType.Health:
			if drop_item.data == DropHeathValues.HealthSmall:
				player.set_health(player.get_health() + 0.15 * player.get_player_max_hp())
			elif drop_item.data == DropHeathValues.HealthMedium:
				player.set_health(player.get_health() + 0.25 * player.get_player_max_hp())
			elif drop_item.data == DropHeathValues.HealthBig:
				player.set_health(player.get_health() + 0.25 * player.get_player_max_hp())
		elif drop_item.ty == DropItemType.Melee:
			WeaponManager.set_melee(drop_item.data)
			print("You got a melee from item drop")
		elif drop_item.ty == DropItemType.Tome:
			WeaponManager.set_tome(drop_item.data)
			print("You got a tome from item drop")
		queue_free()

func _on_area_entered(area):
	if area.owner is Player:
		is_in_range = true
		sprite_2d.modulate.a = 0.75

func _on_area_exited(area):
	if area.owner is Player:
		is_in_range = false
		sprite_2d.modulate.a = 1.0
