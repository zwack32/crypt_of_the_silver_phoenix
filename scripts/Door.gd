extends StaticBody2D
class_name Door

@export var direction: Vector2
@export var original_room_idx: int
@export var room_manager: RoomManager

@onready var enter_trigger = $EnterTrigger
@onready var collider = $CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	enter_trigger.position = -Vector2.UP * 100.0
	rotation = direction.angle() + PI / 2
	
	#sprite_2d.hide()
	
	animated_sprite_2d.play("opening")

func set_disabled(disabled: bool):
	collider.disabled = disabled
	if disabled:
		# pass
		#sprite_2d.hide()
		animated_sprite_2d.play("open")
	else:
		# pass
		#sprite_2d.show()
		animated_sprite_2d.play("closed")

func _on_enter_trigger_area_entered(area):
	if area.owner is Player:
		room_manager.enter_room(original_room_idx)

func _on_enter_trigger_area_exited(area):
	if area.owner is Player:
		room_manager.exit_room(original_room_idx)

func _on_keep_in_trigger_left_area_entered(area):
	if area.owner is Player:
		var player: Player = area.owner
		player.bounce_towards(-player.velocity.normalized() * 3.0)

func _on_keep_in_trigger_right_area_entered(area):
	if area.owner is Player:
		var player: Player = area.owner
		player.bounce_towards(-player.velocity.normalized() * 3.0)
