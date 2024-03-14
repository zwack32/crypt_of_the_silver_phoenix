extends Tome

var str = 7


# Called when the node enters the scene tree for the first time.
func _ready():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var direction = (mouse_pos - position).normalized()
	
	rotation = acos(direction.x)
	#this is probably going to only do it on one side
	#fuck arccos
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(delta).timeout
	set_collision_layer_value(1, 0)
