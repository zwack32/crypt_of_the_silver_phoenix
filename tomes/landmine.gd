#this is mostly copy-pasted from a broken sunburstl; fix later

extends Tome
var str = 15
var type = "null"
var entered_once = false
@export var cooldown = 4.0
@onready var bead_sprite = $BeadSprite
@onready var cpu_particles_2d = $CPUParticles2D

func _ready():
	look_at(get_global_mouse_position())
	position = player.position
	
func _process(delta):
	set_collision_layer_value(1, 0)
	
func _on_area_entered(area):
	bead_sprite.hide()
	if !entered_once:
		entered_once = true
	scale = Vector2(4, 4)
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(0.3).timeout
	queue_free()
