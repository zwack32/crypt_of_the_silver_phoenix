extends Tome

var str = 15
var velocity = Vector2.ZERO
var speed = 700.0
var type = "glow"
var entered_once = false

@export var cooldown = 4.0

@onready var bead_sprite = $BeadSprite
#@onready var cpu_particles_2d = $CPUParticles2D
@onready var sunburst_animation = $SunburstAnimation


# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())
	position = player.position
	bead_sprite.show()
	sunburst_animation.hide()

func _process(delta):
	move_local_x(10.0, false)
	set_collision_layer_value(1, 0)

func _on_area_entered(area):
	bead_sprite.hide()
	sunburst_animation.show()
	if !entered_once: 
		entered_once = true
		scale = Vector2(4, 4)
		#cpu_particles_2d.emitting = true
		sunburst_animation.play("sunburst")
		velocity = Vector2.ZERO
		
		await get_tree().create_timer(0.3).timeout
		queue_free()
