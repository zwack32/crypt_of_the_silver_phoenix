extends Tome

var str = 15
var velocity = Vector2.ZERO
var speed = 80.0
var type = "glow"
var entered_once = false

@export var cooldown = 4.0

@onready var bead_sprite = $BeadSprite
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
	set_collision_layer_value(1, 0)

func _on_area_entered(area):
	bead_sprite.hide()
	if !entered_once: 
		entered_once = true
		scale = Vector2(4, 4)
		cpu_particles_2d.emitting = true
		velocity = Vector2.ZERO
		
		await get_tree().create_timer(0.3).timeout
		queue_free()
