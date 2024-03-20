extends CanvasLayer

@onready var weapon_rect = $WeaponRect
@onready var tome_rect = $TomeRect
@onready var level_label = $RichTextLabel

func _ready():
	level_label.text = "Level: " + str(Progression.get_dungeon_level())

func _process(delta):
	weapon_rect.texture = WeaponManager.get_melee_texture(WeaponManager.current_melee)
	tome_rect.texture = WeaponManager.get_tome_texture(WeaponManager.current_tome)
