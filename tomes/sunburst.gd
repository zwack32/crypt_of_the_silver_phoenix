extends Tome

var str = 0
#actual strength is 5
var velocity = Vector2.ZERO
var speed = 700.0
var type = "glow"
var entered_once = false

@onready var cpu_particles_2d = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport = get_viewport().size
	var screen_mouse_pos = Vector2(mouse_pos.x / viewport.x, mouse_pos.y / viewport.y)
	var coord = screen_mouse_pos * 2.0 - Vector2(1.0, 1.0)
	velocity = coord * speed
	position = player.position

func _process(delta):
	position += velocity

func _on_area_entered(area):
	str = 5
	if !entered_once: 
		entered_once = true
		scale = Vector2(3, 3)
		cpu_particles_2d.emitting = true
		velocity = Vector2.ZERO
		
		# STUB: Replace hordcoded timer pls
		await get_tree().create_timer(0.3).timeout
		queue_free()
