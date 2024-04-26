extends Node2D
class_name IndicatorBorder

@export var player: Player
@export var indicator_scene: PackedScene

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
	# return
	indicators[id].queue_free()
	indicators.erase(id)

func set_indicator_position(id: int, node: Node2D):
	# var space_state = get_world_2d().direct_space_state
	# var query = PhysicsRayQueryParameters2D.create(player.global_position, node.global_position, (1 << 10), [])
	# query.collide_with_areas = true
	# query.collide_with_bodies = false
	# query.hit_from_inside = true
	# var result = space_state.intersect_ray(query)
	
	# if result.has("position"):
	# 	 indicators[id].position = result["position"] - position
	# else:
	#	 print("No, not today thanks")
	
	var u = Vector2.UP * 2 + global_position
	var v = node.global_position - player.global_position
	
	var projuv = (u.dot(v) / v.dot(v)) * v
	print(projuv)
	indicators[id].position = projuv
