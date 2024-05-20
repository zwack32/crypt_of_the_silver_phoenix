extends Node

static var current_melee: MeleeWeaponType = get_initial_melee()
static var current_tome: TomeType = randi_range(0, TomeType._Count - 1)

static func get_initial_melee():
	var rand = randi_range(0, 4)
	if rand == 0:
		return MeleeWeaponType.ShortSword
	if rand == 1:
		return MeleeWeaponType.LongSword
	if rand == 2:
		return MeleeWeaponType.GreatSword
	if rand == 3:
		return MeleeWeaponType.Axe
	if rand == 4:
		return MeleeWeaponType.Hammer

const SHORTSWORD = preload("res://weapons/shortsword.tscn")
const LONGSWORD = preload("res://weapons/longsword.tscn")
const GREATSWORD = preload("res://weapons/greatsword.tscn")
const FIRE_SWORD = preload("res://weapons/fire_sword.tscn")
const ICE_SWORD = preload("res://weapons/ice_sword.tscn")
const SUN_SWORD = preload("res://weapons/sun_sword.tscn")
const AXE = preload("res://weapons/axe.tscn")
const HAMMER = preload("res://weapons/hammer.tscn")
const SCYTHE = preload("res://weapons/scythe.tscn")

const FIREBALL = preload("res://tomes/fireball.tscn")
const ICE_CONE = preload("res://tomes/ice_cone.tscn")
const SUNBURST = preload("res://tomes/sunburst.tscn")

const FLAME_SWORD_TEXTURE = preload("res://art/firesword.png")
const GREATSWORD_TEXTURE = preload("res://art/greatsword (1).png")
const ICE_SWORD_TEXTURE = preload("res://art/icesword.png")
const LONGSWORD_TEXTURE = preload("res://art/longsword (1).png")
const SHORTSWORD_TEXTURE = preload("res://art/shortsword (1).png")
const SUNSWORD_TEXTURE = preload("res://art/sunsword.png")
const AXE_TEXTURE = preload("res://art/axe-Sheet.png")
const HAMMER_TEXTURE = preload("res://art/hammeraxe.png")
const SCYTHE_TEXTURE = preload("res://art/scythe (1).png")

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
	Axe = 6,
	Hammer = 7,
	Scythe = 8,
	_Count,
}

enum TomeType {
	Fireball = 0,
	IceCone = 1,
	Sunburst = 2,
	_Count,
}

static func set_melee(melee: MeleeWeaponType):
	if !MeleeWeaponType.find_key(melee):
		push_error("Bad melee value used in set_melee function")
	current_melee = melee

static func get_melee_scene() -> PackedScene:
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
	elif current_melee == MeleeWeaponType.Axe:
		return AXE
	elif current_melee == MeleeWeaponType.Hammer:
		return HAMMER
	elif current_melee == MeleeWeaponType.Scythe:
		return SCYTHE
	else:
		push_error("Bad melee value used, check set_melee call")
		return null
		
static func get_melee_texture(melee: MeleeWeaponType) -> Texture2D:
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
	elif melee == MeleeWeaponType.Axe:
		return AXE_TEXTURE
	elif melee == MeleeWeaponType.Hammer:
		return HAMMER_TEXTURE
	elif melee == MeleeWeaponType.Scythe:
		return SCYTHE_TEXTURE
	else:
		push_error("Bad melee value used in get_melee_texture function")
		return null

static func set_tome(tome: TomeType):
	if !TomeType.find_key(tome):
		push_error("Bad tome value used in set_tome function")
	current_tome = tome

static func get_tome_scene() -> PackedScene:
	if current_tome == TomeType.Fireball:
		return FIREBALL
	elif current_tome == TomeType.IceCone:
		return ICE_CONE
	elif current_tome == TomeType.Sunburst:
		return SUNBURST
	else:
		push_error("Bad tome value used, check set_tome call")
		return null
		
static func get_tome_animation(tome: TomeType) -> String:
	if tome == TomeType.Fireball:
		return "FireballTexture"
	elif tome == TomeType.IceCone:
		return "IceconeTexture"
	elif tome == TomeType.Sunburst:
		return "SunburstTexture"
	else:
		push_error("Bad tome value used in get_tome_texture function")
		return "null"

func reset():
	current_melee = randi_range(0, MeleeWeaponType._Count - 1)
	current_tome = randi_range(0, TomeType._Count - 1)
	
func get_current_melee():
	return current_melee
