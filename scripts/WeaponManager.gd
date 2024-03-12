extends Node
class_name WeaponManager

var current_melee: MeleeWeaponType = 0
var current_tome: TomeType = 0

const SHORTSWORD = preload("res://weapons/shortsword.tscn")
const LONGSWORD = preload("res://weapons/longsword.tscn")
const GREATSWORD = preload("res://weapons/greatsword.tscn")
const FIRE_SWORD = preload("res://weapons/fire_sword.tscn")
const ICE_SWORD = preload("res://weapons/ice_sword.tscn")
const SUN_SWORD = preload("res://weapons/sun_sword.tscn")

const FIREBALL = preload("res://scenes/fireball.tscn")

enum MeleeWeaponType {
	ShortSword = 0,
	LongSword = 1,
	GreatSword = 2,
	FireSword = 3,
	IceSword = 4,
	SunSword = 5,
}

enum TomeType {
	FireBall = 0
}

func set_melee(melee: MeleeWeaponType):
	if !MeleeWeaponType.find_key(melee):
		push_error("Bad melee value used in set_melee function")
	current_melee = melee

func get_melee_scene() -> PackedScene:
	if current_melee == MeleeWeaponType.ShortSword:
		return SHORTSWORD
	elif current_melee == MeleeWeaponType.LongSword:
		return LONGSWORD
	elif current_melee == MeleeWeaponType.GreatSword:
		return GREATSWORD
	elif current_melee == MeleeWeaponType.FireSword:
		return FIRE_SWORD
	elif current_melee == MeleeWeaponType.IceSword:
		return ICE_SWORD
	elif current_melee == MeleeWeaponType.SunSword:
		return SUN_SWORD
	else:
		push_error("Bad melee value used, check set_melee call")
		return null

func set_tome(tome: TomeType):
	if !TomeType.find_key(tome):
		push_error("Bad tome value used in set_tome function")
	current_tome = tome

func get_tome_scene() -> PackedScene:
	if current_tome == TomeType.FireBall:
		return FIREBALL
	else:
		push_error("Bad tome value used, check set_tome call")
		return null
