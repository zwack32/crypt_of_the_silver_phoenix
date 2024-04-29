extends CanvasLayer

@onready var weapon_rect = $WeaponRect
@onready var tome_rect = $TomeRect
@onready var level_label = $RichTextLabel
@onready var tome_player = $MarginContainer/TomeTexture

func _ready():
	level_label.text = "Level: " + str(Progression.get_dungeon_level())

var current_anim = "";
func _process(delta):
	weapon_rect.texture = WeaponManager.get_melee_texture(WeaponManager.current_melee)
	var tome_anim = WeaponManager.get_tome_animation(WeaponManager.current_tome)
	if current_anim != tome_anim:
		tome_player.animation = tome_anim;
		tome_player.play(); 
		current_anim = tome_anim
