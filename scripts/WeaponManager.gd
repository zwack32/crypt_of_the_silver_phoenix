extends Node
class_name WeaponManager

@export var current_melee: MeleeWeaponType = randi_range(0, MeleeWeaponType._Count - 1)
# var current_tome: TomeType = randi_range(0, TomeType._Count - 1)
@export var current_tome: TomeType = randi_range(0, TomeType._Count - 1)

const SHORTSWORD = preload("res://weapons/shortsword.tscn")
const LONGSWORD = preload("res://weapons/longsword.tscn")
const GREATSWORD = preload("res://weapons/greatsword.tscn")
const FIRE_SWORD = preload("res://weapons/fire_sword.tscn")
const ICE_SWORD = preload("res://weapons/ice_sword.tscn")
const SUN_SWORD = preload("res://weapons/sun_sword.tscn")

const FIREBALL = preload("res://tomes/fireball.tscn")
const ICE_CONE = preload("res://tomes/ice_cone.tscn")
const SUNBURST = preload("res://tomes/sunburst.tscn")

const FLAME_SWORD_TEXTURE = preload("res://art/flame_sword.png")
const GREATSWORD_TEXTURE = preload("res://art/greatsword.png")
const ICE_SWORD_TEXTURE = preload("res://art/ice_sword.png")
const LONGSWORD_TEXTURE = preload("res://art/longsword.png")
const SHORTSWORD_TEXTURE = preload("res://art/shortsword.png")
const SUNSWORD_TEXTURE = preload("res://art/sunsword.png")

const FIREBALL_TEXTURE = preload("res://art/fireball.png")
const SUNBURST_TEXTURE = preload("res://art/sunburst.png")
const ICE_CONE_TEXTURE = preload("res://art/ice_cone.png")

enum MeleeWeaponType {
	ShortSword = 0,
	LongSword = 1,
	GreatSword = 2,
	FireSword = 3,
	IceSword = 4,
	SunSword = 5,
	_Count,
}

enum TomeType {
	Fireball = 0,
	IceCone = 1,
	Sunburst = 2,
	_Count,
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
		
func get_melee_texture(melee: MeleeWeaponType) -> Texture2D:
	if melee == MeleeWeaponType.ShortSword:
		return SHORTSWORD_TEXTURE
	elif melee == MeleeWeaponType.LongSword:
		return LONGSWORD_TEXTURE
	elif melee == MeleeWeaponType.GreatSword:
		return GREATSWORD_TEXTURE
	elif melee == MeleeWeaponType.FireSword:
		return FLAME_SWORD_TEXTURE
	elif melee == MeleeWeaponType.IceSword:
		return ICE_SWORD_TEXTURE
	elif melee == MeleeWeaponType.SunSword:
		return SUNSWORD_TEXTURE
	else:
		push_error("Bad melee value used in get_melee_texture function")
		return null

func set_tome(tome: TomeType):
	if !TomeType.find_key(tome):
		push_error("Bad tome value used in set_tome function")
	current_tome = tome

func get_tome_scene() -> PackedScene:
	if current_tome == TomeType.Fireball:
		return FIREBALL
	elif current_tome == TomeType.IceCone:
		return ICE_CONE
	elif current_tome == TomeType.Sunburst:
		return SUNBURST
	else:
		push_error("Bad tome value used, check set_tome call")
		return null
		
func get_tome_texture(tome: TomeType) -> Texture2D:
	if tome == TomeType.Fireball:
		return FIREBALL_TEXTURE
	elif tome == TomeType.IceCone:
		return ICE_CONE_TEXTURE
	elif tome == TomeType.Sunburst:
		return SUNBURST_TEXTURE
	else:
		push_error("Bad tome value used in get_tome_texture function")
		return null
