extends CanvasLayer

@onready var weapon_rect = $WeaponRect
@onready var tome_rect = $TomeRect
@export var weapon_manager: WeaponManager

func _process(delta):
	weapon_rect.texture = weapon_manager.get_melee_texture(weapon_manager.current_melee)
	tome_rect.texture = weapon_manager.get_tome_texture(weapon_manager.current_tome)
