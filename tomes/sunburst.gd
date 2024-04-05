extends Tome

var str = 15
var velocity = Vector2.ZERO
var speed = 70.0
var type = "glow"
var entered_once = false

@export var cooldown = 4.0

@onready var bead_sprite = $BeadSprite
#@onready var cpu_particles_2d = $CPUParticles2D
@onready var sun_burst = $SunBurst


# Called when the node enters the scene tree for the first time.
func _ready():
	var coord = get_global_mouse_position()
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
		#cpu_particles_2d.emitting = true
		sun_burst.play("sun burst")
		velocity = Vector2.ZERO
		
		await get_tree().create_timer(0.3).timeout
		queue_free()
