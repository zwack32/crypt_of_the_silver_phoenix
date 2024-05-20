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
@onready var sunburst_sound = $SunburstSound


# Called when the node enters the scene tree for the first time.
func _ready():
	position = player.position
	velocity = global_position.direction_to(get_global_mouse_position()) * speed
	bead_sprite.show()
	sunburst_animation.hide()

func _process(delta):
	position += velocity * delta
	#set_collision_layer_value(0,2)

func _on_area_entered(area):
	if !entered_once && !(area.owner is Player):
		entered_once = true
		scale = Vector2(4, 4)
		sunburst_sound.play(2)
		boom()

func _on_body_entered(body):
	sunburst_sound.play(1.5)
	boom()

func boom():
	player.apply_shake()
	bead_sprite.hide()
	sunburst_animation.show()
	#cpu_particles_2d.emitting = true
	sunburst_animation.play("sunburst")
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.3).timeout
	queue_free()
