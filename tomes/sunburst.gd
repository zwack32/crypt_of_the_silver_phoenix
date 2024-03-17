extends Tome

var str = 0
#actual strength is 5
var velocity = Vector2.ZERO
var speed = 700.0
var type = "glow"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var direction = (mouse_pos - position).normalized()
	velocity = direction * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity
	

func _on_area_entered(area):
	str = 5
	
	scale *= 3
	
	await get_tree().create_timer(0.016).timeout
	set_collision_layer_value(1, 0)
