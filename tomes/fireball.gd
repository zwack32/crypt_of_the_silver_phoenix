extends Tome

var str = 10
var type = "fire"
@export var cooldown = 6.0

@onready var cpu_particles_2d = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_global_mouse_position()
	
	cpu_particles_2d.emitting = true
	
	await get_tree().create_timer(1).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(delta).timeout
	set_collision_layer_value(1, 0)
