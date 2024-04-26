extends Node2D
class_name IndicatorBorder

@export var player: Player
@export var indicator_scene: PackedScene

@onready var indicator_raycast = $RayCast2D

var indicators = {}
var indicator_total = 0

func _process(delta):
	position = player.camera.get_screen_center_position()

func enable_indicator() -> int:
	var indicator = indicator_scene.instantiate()
	add_child(indicator)
	indicators[indicator_total] = indicator
	indicator_total += 1
	return indicator_total - 1
	
func disable_indicator(id: int):
	indicators[id].queue_free()
	indicators.erase(id)

func set_indicator_position(id: int, node: Node2D):
	indicator_raycast.target_position = to_local(node.global_position)
	indicator_raycast.force_raycast_update()
	var collider = indicator_raycast.get_collider()
	if (collider != null):
		print("found collision for raycast for object %s" % node.name)
		print("collided with %s" % collider.name)
		indicators[id].visible = true
		var collision_point = indicator_raycast.get_collision_point()
		indicators[id].global_position = collision_point
	else:
		print("no collider found for object %s" % node.name)
		indicators[id].visible = false
		
