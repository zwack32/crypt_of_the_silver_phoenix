extends Tome

var str = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport().get_mouse_position()+player.position
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var viewport = get_viewport().size
	var screen_mouse_pos = Vector2(mouse_pos.x / viewport.x, mouse_pos.y / viewport.y)
	#print(screen_mouse_pos * 2.0 - Vector2(1.0, 1.0))
	#aaaaaaa
	position = (screen_mouse_pos * 2.0 - Vector2(1.0, 1.0))
	position.x *= viewport.x / 2
	position.y *= viewport.y / 2
	position += player.position
	
	await get_tree().create_timer(2).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(delta).timeout
	set_collision_layer_value(1, 0)
