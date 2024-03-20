extends CanvasLayer

@onready var weapon_rect = $WeaponRect
@onready var tome_rect = $TomeRect

func _process(delta):
	weapon_rect.texture = WeaponManager.get_melee_texture(WeaponManager.current_melee)
	tome_rect.texture = WeaponManager.get_tome_texture(WeaponManager.current_tome)
